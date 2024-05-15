package com.team4.cbs.util;

import java.util.List;

//페이징 관련 정보 + 게시글 정보
// new ArticlePage<FreeBoardVO>(total, currentPage, size, content);
public class MiniPage<T> {
	//전체글 수
	private int total;
	// 현재 페이지 번호
	private int currentPage;
	// 전체 페이지수 
	private int totalPages;
	// 블록의 시작 페이지 번호
	private int startPage;
	//블록의 종료 페이지 번호
	private int endPage;
	//검색어
	private String keyword = "";
	//요청URL
	private String url = "";
	//select 결과 데이터
	private List<T> content;
	//페이징 처리
	private String pagingArea = "";
	//블록 크기
	private int blockSize = 3;
	//공통 코드[검색조건]
	private String comCode;
	//공통 코드 상세 명[검색조건]
	private String comCodeDetNm;
	
	//생성자(Constructor) : 페이징 정보를 생성
	//					753				1				10			select결과10행, comCode, comCodeDetNm
	public MiniPage(int total, int currentPage, int size, List<T> content, String comCode, String comCodeDetNm) {
		//size : 한 화면에 보여질 목록의 행 수
		this.total = total;//753
		this.currentPage = currentPage;//1
		this.content = content;
		this.comCode = comCode;
		this.comCodeDetNm = comCodeDetNm;
		
		//전체글 수가 0이면?
		if(total==0) {
			totalPages = 0;//전체 페이지 수
			startPage = 0;//블록 시작번호
			endPage = 0; //블록 종료번호
		}else {//글이 있다면
			//전체 페이지 수 = 전체글 수 / 한 화면에 보여질 목록의 행 수
			//3 = 31 / 10
			totalPages = total / size;//75
			
			//나머지가 있다면, 페이지를 1 증가
			if(total % size > 0) {//나머지3
				totalPages++;//76
			}
			
			//페이지 블록 시작번호를 구하는 공식
			// 블록시작번호 = 현재페이지 / 페이지크기 * 페이지크기 + 1
			startPage = currentPage / blockSize * blockSize + 1;//1
			
			//현재페이지 % 페이지크기 => 0일 때 보정
			if(currentPage % blockSize == 0) {
				startPage -= blockSize;
			}
			
			//블록종료번호 = 시작페이지번호 + (페이지크기 - 1)
			//[1][2][3][다음]
			endPage = startPage + (blockSize - 1);//5
			
			//종료페이지번호 > 전체페이지수
			if(endPage > totalPages) {
				endPage = totalPages;
			}
		}
		
//		pagingArea += "<div class='col-sm-12 col-md-7'>";
//		pagingArea += "<div class='dataTables_paginate paging_simple_numbers' id='example2_paginate'>";
//		pagingArea += "<ul class='pagination'>";
//		pagingArea += "<li class='paginate_button page-item previous "; 
//		if(this.startPage<4) {
//			pagingArea += "disabled ";
//		}
//		pagingArea += "'";
//		pagingArea += "id='example2_previous'>";
//		pagingArea += "<a href='"+this.url+"?currentPage="+(this.startPage-blockSize)+"&comCode="+this.comCode+"&comCodeDetNm="+this.comCodeDetNm+"' aria-controls='example2' data-dt-idx='0' tabindex='0' ";
//		pagingArea += "class='page-link'>Previous</a></li>";
//		
//		for(int pNo=this.startPage;pNo<=this.endPage;pNo++) {		
//		pagingArea += "<li class='paginate_button page-item ";
//			if(this.currentPage == pNo) {
//				pagingArea += "active";
//			}
//			pagingArea += "'>";
//			pagingArea += "<a href='"+this.url+"?currentPage="+pNo+"&comCode="+this.comCode+"&comCodeDetNm="+this.comCodeDetNm+"' aria-controls='example2' data-dt-idx='1' tabindex='0' ";
//			pagingArea += "class='page-link'>"+pNo+"</a>";
//			pagingArea += "</li>";
//		}
//		pagingArea += "<li class='paginate_button page-item next "; 
//		if(this.endPage>=this.totalPages) {
//			pagingArea += "disabled";
//		}
//		pagingArea += "' id='example2_next'><a ";
//		pagingArea += "href='"+this.url+"?currentPage="+(this.startPage+blockSize)+"&comCode="+this.comCode+"&comCodeDetNm="+this.comCodeDetNm+"' aria-controls='example2' data-dt-idx='7' ";
//		pagingArea += "tabindex='0' class='page-link'>Next</a></li>";
//		pagingArea += "</ul>";
//		pagingArea += "</div>";
//		pagingArea += "</div>";
		
		pagingArea += "<div class='jsgrid-pager-container text-center'>";
		pagingArea += "<div class='jsgrid-pager'>";
		pagingArea += "<span class='jsgrid-pager-nav-button jsgrid-pager-nav-";
		if(this.startPage<4) {
			pagingArea += "inactive-";
		}
		pagingArea += "button'>"; 
		pagingArea += "<a href='"+this.url+"?currentPage="+(this.startPage-blockSize)+"&comCode="+this.comCode+"&comCodeDetNm="+this.comCodeDetNm+"'>Prev</a>";
		pagingArea += "</span>";
		for(int pNo=this.startPage;pNo<=this.endPage;pNo++) {
			pagingArea += "<span class='jsgrid-pager-page'><a href='"+this.url+"?currentPage="+pNo+"&comCode="+this.comCode+"&comCodeDetNm="+this.comCodeDetNm+"'>"+pNo+"</a></span>";
		}
		pagingArea += "<span class='jsgrid-pager-nav-";
		if(this.endPage>=this.totalPages) {
			pagingArea += "inactive-";
		}
		pagingArea += "button'>";
		pagingArea += "<a href='"+this.url+"?currentPage="+(this.startPage+blockSize)+"&comCode="+this.comCode+"&comCodeDetNm="+this.comCodeDetNm+"'>Next</a>";
		pagingArea += "</span>"; 
		pagingArea += "</div>";
		pagingArea += "</div>";
	}//end 생성자

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}

	public int getTotalPages() {
		return totalPages;
	}

	public void setTotalPages(int totalPages) {
		this.totalPages = totalPages;
	}

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public List<T> getContent() {
		return content;
	}

	public void setContent(List<T> content) {
		this.content = content;
	}
	
	//전체 글의 수가 0인가?
	public boolean hasNoArticles() {
		return this.total == 0;
	}
	
	//데이터가 있나?
	public boolean hasArticles() {
		return this.total > 0;
	}
	
	public void setPagingArea(String pagingArea) {
		this.pagingArea = pagingArea;
	}

	//페이징 블록을 자동화
	public String getPagingArea() {
		return this.pagingArea;
	}

	public int getBlockSize() {
		return blockSize;
	}

	public void setBlockSize(int blockSize) {
		this.blockSize = blockSize;
	}
	
	
}







