#!/usr/bin/env perl

# Author: philsmd
# License: public domain
# First released: February 2017

use strict;
use warnings;

# CONSTANTS

my $HCCAPX_STRUCT_SIZE  = 393;
my $HCCAPX_STRUCT_MAGIC = "\x48\x43\x50\x58"; # HCPX

# START

if (scalar (@ARGV) < 1)
{
  print ("ERROR: Please specify the .hccapx file\n");

  exit (1);
}

my $hccapx_file = $ARGV[0];


my @filter = ();

if (scalar (@ARGV) > 1)
{
  my $filter_line = $ARGV[1];

  if ($filter_line !~ /^[0-9,]*$/ )
  {
    print ("ERROR: format of filter is incorrect, it must be a comma-separated list of numbers\n");

    exit (1);
  }

  @filter = split (',', $filter_line);
}

if (! open (HCCAPX_FILE, $hccapx_file))
{
  print ("ERROR: Could not open the .hccapx file '$hccapx_file'\n");

  exit (1);
}

binmode (HCCAPX_FILE);

my $stop = 0;

my $struct_content = "";

my $count_printed  = 0;
my $count_total    = 1;

while (read (HCCAPX_FILE, $struct_content, $HCCAPX_STRUCT_SIZE))
{
  if (scalar (@filter) > 0)
  {
    my $found = 0;

    foreach my $num (@filter)
    {
      if ($num eq $count_total)
      {
        $found = 1;

        last;
      }
    }

    if (! $found)
    {
      $count_total++;

      next;
    }
  }

  print "\n" if ($count_printed > 0);

  # check the signature/magic

  my $first_4_bytes = substr ($struct_content, 0, 4);

  if ($first_4_bytes ne $HCCAPX_STRUCT_MAGIC)
  {
    print STDERR "WARNING: Could not find the HCCAPX magic ($HCCAPX_STRUCT_MAGIC) on item number $count_total\n";

    $count_total++;

    next;
  }

  my $version      = substr ($struct_content,   4,   4);
  my $message_pair = substr ($struct_content,   8,   1);
  my $essid_len    = substr ($struct_content,   9,   1);
  my $essid        = substr ($struct_content,  10,  32);
  my $keyver       = substr ($struct_content,  42,   1);
  my $keymic       = substr ($struct_content,  43,  16);
  my $mac_ap       = substr ($struct_content,  59,   6);
  my $nonce_ap     = substr ($struct_content,  65,  32);
  my $mac_sta      = substr ($struct_content,  97,   6);
  my $nonce_sta    = substr ($struct_content, 103,  32);
  my $eapol_len    = substr ($struct_content, 135,   2);

  $eapol_len = unpack ("S*", $eapol_len);

  if ($eapol_len > 256)
  {
    print STDERR "WARNING: Invalid eapol length ($eapol_len) on item number $count_total\n";

    $count_total++;

    next;
  }

  my $eapol = substr ($struct_content, 137, $eapol_len);


  # nicer display of the message pair

  my $message_pair_info = "";

  if ($message_pair eq "\x00")
  {
    $message_pair_info = "message 1 + message 2";
  }
  elsif ($message_pair eq "\x01")
  {
    $message_pair_info = "message 1 + message 4";
  }
  elsif ($message_pair eq "\x02")
  {
    $message_pair_info = "message 2 + message 3";
  }
  elsif ($message_pair eq "\x03")
  {
    $message_pair_info = "message 2 + message 3";
  }
  elsif ($message_pair eq "\x04")
  {
    $message_pair_info = "message 3 + message 4";
  }
  elsif ($message_pair eq "\x05")
  {
    $message_pair_info = "message 3 + message 4";
  }
  else
  {
    $message_pair_info = "unknown message pair";
  }

  # nicer display of the key version:

  my $keyver_info = "";

  if ($keyver eq "\x00")
  {
    $keyver_info = "incorrect key version";
  }
  elsif ($keyver eq "\x01")
  {
    $keyver_info = "WPA";
  }
  else
  {
    $keyver_info = "WPA2";
  }

  print "HCCAPX {\n";
  print "  version:      " . unpack ("L*", $version) . "\n";
  print "  message_pair: " . unpack ("C*", $message_pair) . " (" . $message_pair_info . ")\n";
  print "  essid:        " . $essid . "\n";
  print "  keyver:       "   . unpack ("C*", $keyver) . " (" . $keyver_info . ")\n";
  print "  keymic:       "   . unpack ("H*", $keymic) . "\n";
  print "  MACS:\n";
  print "    mac_ap:  "  . unpack ("H*", $mac_ap)  . "\n";
  print "    mac_sta: "  . unpack ("H*", $mac_sta) . "\n";
  print "  NONCES:\n";
  print "    nonce_ap:  " . unpack ("H*", $nonce_ap) . "\n";
  print "    nonce_sta: " . unpack ("H*", $nonce_sta) . "\n";
  print "  EAPOL:\n";
  print "    size:  " . $eapol_len . "\n";
  print "    eapol: " . unpack ("H*", $eapol)  . "\n";
  print "}\n";

  $count_total++;
  $count_printed++;
}

close (HCCAPX_FILE);

exit (0);
