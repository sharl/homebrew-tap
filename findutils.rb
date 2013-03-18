require 'formula'

class Findutils < Formula
  homepage 'http://www.gnu.org/software/findutils/'
  url 'http://ftpmirror.gnu.org/findutils/findutils-4.4.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/findutils/findutils-4.4.2.tar.gz'
  sha1 'e8dd88fa2cc58abffd0bfc1eddab9020231bb024'

  option 'default-names', "Do not prepend 'g' to the binary"
  option 'with-sort=</path/to/sort>', 'Configure with a specified sort'

  def which_sort
    ARGV.each do |a|
      if a.index('--with-sort')
        sort = a.sub('--with-sort=', '')
        raise "#{sort} not found" if not File.exists? "#{sort}"

        return sort
      end
    end
    return ""
  end

  def patches
    DATA
  end

  def install
    args = ["--prefix=#{prefix}",
            "--localstatedir=#{var}/locate",
            "--disable-dependency-tracking",
            "--disable-debug"]
    args << "--program-prefix=g" unless build.include? 'default-names'
    sort = which_sort
    args << "SORT=#{sort}" if sort

    system "./configure", *args
    system "make install"
  end
end
__END__
--- a/locate/updatedb.sh
+++ b/locate/updatedb.sh
@@ -21,6 +21,8 @@
 #exec 2> /tmp/updatedb-trace.txt 
 #set -x
 
+export LC_ALL=C
+
 version='
 updatedb (@PACKAGE_NAME@) @VERSION@
 Copyright (C) 2007 Free Software Foundation, Inc.
@@ -158,7 +160,7 @@
 : ${NETPATHS=}
 
 # Directories to not put in the database, which would otherwise be.
-: ${PRUNEPATHS="/tmp /usr/tmp /var/tmp /afs /amd /sfs /proc"}
+: ${PRUNEPATHS="/tmp /usr/tmp /var/tmp /afs /amd /sfs /Volumes"}
 
 # Trailing slashes result in regex items that are never matched, which 
 # is not what the user will expect.   Therefore we now reject such 
@@ -347,7 +349,7 @@
 } | tr / '\001' | $sort -f | tr '\001' / > $filelist
 
 # Compute the (at most 128) most common bigrams in the file list.
-$bigram $bigram_opts < $filelist | sort | uniq -c | sort -nr |
+$bigram $bigram_opts < $filelist | $sort | uniq -c | $sort -nr |
   awk '{ if (NR <= 128) print $2 }' | tr -d '\012' > $bigrams
 
 # Code the file list.
