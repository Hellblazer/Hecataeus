/*
 Copyright (c) 1995-2000 by the Hypersonic SQL Group. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of the Hypersonic SQL Group nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE HYPERSONIC SQL GROUP, OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

This software consists of voluntary contributions made by many individuals on behalf of the Hypersonic SQL Group. 
 
 */
/*
 * StringConverter.java
 */

package edu.ntua.dblab.hecataeus.hsql;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.sql.SQLException;

class StringConverter {
  private static final char HEXCHAR[]={
    '0','1','2','3','4','5','6','7',
    '8','9','a','b','c','d','e','f'
  };
  private static final String HEXINDEX="0123456789abcdef          ABCDEF";

  public static byte[] hexToByte(String s) {
    int l=s.length()/2;
    byte data[]=new byte[l];
    int j=0;
    for(int i=0;i<l;i++) {
      char c=s.charAt(j++);
      int n,b;
      n=HEXINDEX.indexOf(c);
      b=(n & 0xf) << 4;
      c=s.charAt(j++);
      n=HEXINDEX.indexOf(c);
      b+=(n & 0xf);
      data[i]=(byte)b;
    }
    return data;
  }
  static String byteToHex(byte b[]) {
    int len=b.length;
    StringBuffer s=new StringBuffer();
    for(int i=0;i<len;i++) {
      int c=((int)b[i]) & 0xff;
      s.append(HEXCHAR[c>>4 & 0xf]);
      s.append(HEXCHAR[c & 0xf]);
    }
    return s.toString();
  }
  static String unicodeToHexString(String s) {
    ByteArrayOutputStream bout=new ByteArrayOutputStream();
    DataOutputStream out=new DataOutputStream(bout);
    try {
      out.writeUTF(s);
      out.close();
      bout.close();
    } catch(IOException e) {
      return null;
    }
    return byteToHex(bout.toByteArray());
  }
  public static String hexStringToUnicode(String s) {
    byte[] b=hexToByte(s);
    ByteArrayInputStream bin=new ByteArrayInputStream(b);
    DataInputStream in=new DataInputStream(bin);
    try {
      return in.readUTF();
    } catch(IOException e) {
      return null;
    }
  }
  public static String unicodeToAscii(String s) {
    if(s==null || s.equals("")) {
      return s;
    }
    int len=s.length();
    StringBuffer b=new StringBuffer(len);
    for(int i=0;i<len;i++) {
      char c=s.charAt(i);
      if(c=='\\') {
        if(i<len-1 && s.charAt(i+1)=='u') {
          b.append(c);  // encode the \ as unicode, so 'u' is ignored
          b.append("u005c"); // splited so the source code is not changed...
        } else {
          b.append(c);
        }
      } else if((c>=0x0020)&&(c<=0x007f)) {
        b.append(c);  // this is 99%
      } else {
        b.append("\\u");
        b.append(HEXCHAR[(c>>12) & 0xf]);
        b.append(HEXCHAR[(c>>8) & 0xf]);
        b.append(HEXCHAR[(c>>4) & 0xf]);
        b.append(HEXCHAR[c & 0xf]);

      }
    }
    return b.toString();
  }
  public static String asciiToUnicode(String s) {
    if(s==null || s.indexOf("\\u")==-1) {
      return s;
    }
    int len=s.length();
    char b[]=new char[len];
    int j=0;
    for(int i=0;i<len;i++) {
      char c=s.charAt(i);
      if(c!='\\' || i==len-1) {
        b[j++]=c;
      } else {
        c=s.charAt(++i);
        if(c!='u' || i==len-1) {
          b[j++]='\\';
          b[j++]=c;
        } else {
          int k=(HEXINDEX.indexOf(s.charAt(++i))&0xf)<<12;
          k+=(HEXINDEX.indexOf(s.charAt(++i))&0xf)<<8;
          k+=(HEXINDEX.indexOf(s.charAt(++i))&0xf)<<4;
          k+=(HEXINDEX.indexOf(s.charAt(++i))&0xf);
          b[j++]=(char)k;
        }
      }
    }
    return new String(b,0,j);
  }
  public static String InputStreamToString(InputStream x) throws SQLException {
    InputStreamReader in=new InputStreamReader(x);
    StringWriter write=new StringWriter();
    int blocksize=8*1024; // todo: is this a good value?
    char buffer[]=new char[blocksize];
    try {
      while(true) {
        int l=in.read(buffer,0,blocksize);
        if(l==-1) {
          break;
        }
        write.write(buffer,0,l);
      }
      write.close();
      x.close();
    } catch(IOException e) {
      throw Trace.error(Trace.INPUTSTREAM_ERROR,e.getMessage());
    }
    return write.toString();
  }
}

