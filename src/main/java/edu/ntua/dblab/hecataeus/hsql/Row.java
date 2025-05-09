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
 * Row.java
 */

package edu.ntua.dblab.hecataeus.hsql;
import java.io.ByteArrayOutputStream;
import java.io.DataInput;
import java.io.DataOutputStream;
import java.io.IOException;
import java.sql.SQLException;

class Row {
	private Object oData[];
	private Table tTable;  // null: memory row; otherwise: cached table
	// only required for cached table
	static int iCurrentAccess=0;
	// todo: use int iLastChecked;
	int iLastAccess;

	Row rLast;
	Row rNext;
	int iPos;
	int iSize;
	boolean bChanged;
	private Node nFirstIndex;

	Row(Table t,Object o[]) throws SQLException {
		tTable=t;
		int index=tTable.getIndexCount();
		nFirstIndex=new Node(this,0);
		Node n=nFirstIndex;
		for(int i=1;i<index;i++) {
			n.nNext=new Node(this,i);
			n=n.nNext;
		}
		oData=o;
		if(tTable!=null && tTable.cCache!=null) {
			iLastAccess=iCurrentAccess++;
			// todo: 32 bytes overhead for each index + iSize, iPos
			iSize=8+Column.getSize(o,tTable)+32*tTable.getIndexCount();
			iSize=((iSize+7)/8)*8;  // align to 8 byte blocks
			tTable.cCache.add(this);
		}
		bChanged=true;
	}
	void cleanUpCache() throws SQLException {
		if(tTable!=null && tTable.cCache!=null) {
			// so that this row is not cleaned
			iLastAccess=iCurrentAccess++;
			tTable.cCache.cleanUp();
		}
	}
	void changed() {
		bChanged=true;
		iLastAccess=iCurrentAccess++;
	}
	Node getNode(int pos,int index) throws SQLException {
		// return getRow(pos).getNode(index);
		Row r=tTable.cCache.getRow(pos,tTable);
		r.iLastAccess=iCurrentAccess++;
		return r.getNode(index);
	}
	private Row getRow(int pos) throws SQLException {
		return tTable.cCache.getRow(pos,tTable);
	}
	Node getNode(int index) {
		Node n=nFirstIndex;
		while(index-->0) {
			n=n.nNext;
		}
		return n;
	}
	Object[] getData() {
		iLastAccess=iCurrentAccess++;
		return oData;
	}

	// if read from cache
	Row(Table t,DataInput in,int pos,Row before) throws IOException,SQLException {
		tTable=t;
		int index=tTable.getIndexCount();
		iPos=pos;
		nFirstIndex=new Node(this,in,0);
		Node n=nFirstIndex;
		for(int i=1;i<index;i++) {
			n.nNext=new Node(this,in,i);
			n=n.nNext;
		}
		int l=tTable.getInternalColumnCount();
		oData=Column.readData(in,l);
		Trace.check(in.readInt()==iPos,Trace.INPUTSTREAM_ERROR);
		insert(before);
		iLastAccess=iCurrentAccess++;
	}
	void insert(Row before) {
		if(before==null) {
			rNext=this;
			rLast=this;
		} else {
			rNext=before;
			rLast=before.rLast;
			before.rLast=this;
			rLast.rNext=this;
		}
	}
	boolean canRemove() throws SQLException {
		Node n=nFirstIndex;
		while(n!=null) {
			if(Trace.ASSERT) Trace.verify(n.iBalance!=-2);
			if(Trace.STOP) Trace.stop();
			if(n.iParent==0 && n.nParent==null) {
				return true;
			}
			n=n.nNext;
		}
		return false;
	}
	byte[] write() throws IOException,SQLException {
		ByteArrayOutputStream bout=new ByteArrayOutputStream(iSize);
		DataOutputStream out=new DataOutputStream(bout);
		out.writeInt(iSize);
		nFirstIndex.write(out);
		Column.writeData(out,oData,tTable);
		out.writeInt(iPos);
		bChanged=false;
		return bout.toByteArray();
	}
	void delete() throws SQLException {
		if(tTable!=null && tTable.cCache!=null) {
			bChanged=false;
			tTable.cCache.free(this,iPos,iSize);
		}
	}
	void free() throws SQLException {
		rLast.rNext=rNext;
		rNext.rLast=rLast;
		if(rNext==this) {
			rNext=rLast=null;
		}
	}
}

