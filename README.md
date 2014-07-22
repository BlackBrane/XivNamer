XivNamer
========

`XivNamer.rb` is a simple file-renaming script for papers downloaded from arXiv math/physics preprint archive.

These papers generally come with filenames like `1212.5605.pdf`, however if you want to keep and organize a large number of them it's much better to have the filess named according to their actual titles. This can quickly become prohibitively time-consuming if you download from arXiv regularly. XivNamer.rb scans your download folder for filenames with this format, retrives the corresponding abstract summary from the arXiv server, renames them, and puts them in another location of your choosing.

An alternate version, `XivNamerB.rb` is included for arXiv papers authored prior to April 2007. These have a different numbering system for each separate category, making name-retrival more involved. For now the script has you specify which categories you want, and scans a separate folder for each category. You need to put the files into the corresponding folders beforehand.

Information about the arXiv identifiers can be found at http://arxiv.org/help/arxiv_identifier
