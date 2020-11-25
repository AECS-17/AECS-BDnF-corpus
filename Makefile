# Copyright (c) 2020, Frédéric Wang
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

CONVERT=convert
ZIP=zip
SED=sed

all: clean AECS-Decors.zip AECS-Fille.zip AECS-Garcon.zip

%.zip: %
	echo "Generating corpus for "$<" ..."

# Convert SVG images to PNG (high res and thumbnails).
	mkdir -p $</Highres $</Thumbnails
	for name in `cd $< ; find -type f -name '*.svg.in' | $(SED) 's/\.svg\.in//'`; do \
		$(SED) -e 's/fill:#ff0000/fill:#f4d7d7/g' -e 's/fill:#00ff00/fill:#ffeeaa/g' $</$$name.svg.in > $</$$name-peau-claire.svg; \
		$(SED) -e 's/fill:#ff0000/fill:#ffb481/g' -e 's/fill:#00ff00/fill:#280b0b/g' $</$$name.svg.in > $</$$name-peau-mate.svg; \
		$(SED) -e 's/fill:#ff0000/fill:#532200/g' -e 's/fill:#00ff00/fill:#000000/g' $</$$name.svg.in > $</$$name-peau-foncee.svg; \
	done; \
	for name in `cd $< ; find -type f -name '*.svg' | $(SED) 's/\.svg//'`; do \
		$(CONVERT) -background transparent $</$$name.svg -resize 1600x1600 $</Highres/$$name.png; \
	        $(CONVERT) -background transparent $</$$name.svg -resize 160x160 $</Thumbnails/$$name.png; \
	done

# Create The ZIP archive for the corpus.
	cd $<; $(ZIP) -r ../$<.zip Highres Thumbnails Cluster.xml

clean:
	rm -rf */Highres */Thumbnails */*-peau-claire.svg */*-peau-mate.svg */*-peau-foncee.svg

distclean: clean
	rm -f *.zip
