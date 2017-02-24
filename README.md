# About

The goal of this project is to make the content of a hashcat .hccapx file human-readable.
The format of these files is defined here: https://hashcat.net/wiki/hccapx

# Requirements

Software:  
- Perl must be installed (should work on *nix and windows with perl installed)


# Installation and First Steps

* Clone this repository:  
    git clone https://github.com/philsmd/analyze_hccapx.git  
* Enter the repository root folder:
    cd analyze_hccapx
* Get a test hccapx file (e.g):
    wget http://hashcat.net/misc/example_hashes/hashcat.hccapx
* Run it:  
    ./analyze_hccapx.pl hashcat.hccapx
* Check output

There is a second (optional) parameter. It works like a filter and allows you to specify
which of the networks you want to display.
For instance if a .hccapx file has 4 networks in it (i.e. it could be splitted in 4 single
.hccapx files), you can display the single networks like this:  
  ./analyze_hccapx.pl multi.hccapx 2,3  
  

By doing so only the second and third network are shown (out of 4).
It is a comma-separated list. Single networks can also be filtered, for instance:    
  ./analyze_hccapx.pl mutli.hccapx 1  
will show only the first network
 
# Hacking

* More features
* CLEANUP the code, use more coding standards, everything is welcome (submit patches!)
* all bug fixes are welcome
* and,and,and

# Credits and Contributors 
Credits go to:  
  
* philsmd, hashcat project

# License/Disclaimer

License: belongs to the PUBLIC DOMAIN, donated to hashcat, credits MUST go to hashcat and philsmd for their hard work. Thx  
  
Disclaimer: WE PROVIDE THE PROGRAM “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE Furthermore, NO GUARANTEES THAT IT WORKS FOR YOU AND WORKS CORRECTLY
