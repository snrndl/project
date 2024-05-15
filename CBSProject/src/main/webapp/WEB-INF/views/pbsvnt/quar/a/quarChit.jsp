<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script src="/resources/js/jquery.min.js"></script>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
</head>
<body>
	<style type="text/css">
	
@media print {
.tg .tg-i8mc {background-color:#efefef !important; -webkit-print-color-adjust:exact;}
.tg .tg-qbk9 {background-color:#efefef !important; -webkit-print-color-adjust:exact;}

.hpa {margin:0;border:0 black none;}
body {padding:0; font-family: "바탕";}
nav, .no-print {
        display: none; /* 네비게이션과 원치 않는 요소 숨기기 */
    }
}
@page {
    size: A4;
    margin:0
}

svg:not(:host).svg-inline—fa, svg:not(:root).svg-inline—fa {
    overflow: visible;
    box-sizing: content-box;
}

.svg-inline—fa {
    display: var(—fa-display, inline-block);
    height: 1em;
    overflow: visible;
    vertical-align: -.125em;
}
.tg {
	border-collapse: collapse;
	border-spacing: 0;
}

.tg td {
	border-color: black;
	border-style: solid;
	border-width: 1px;
	font-family: Arial, sans-serif;
	font-size: 14px;
	overflow: hidden;
	padding: 10px 5px;
	word-break: normal;
}

.tg th {
	border-color: black;
	border-style: solid;
	border-width: 1px;
	font-family: Arial, sans-serif;
	font-size: 14px;
	font-weight: normal;
	overflow: hidden;
	padding: 10px 5px;
	word-break: normal;
}

.tg .tg-wa1i {
	border-color: inherit;
	font-weight: bold;
	text-align: center;
	vertical-align: middle
}

.tg .tg-qbk9 {
	background-color: #efefef;
	border-color: inherit;
	font-weight: bold;
	text-align: center;
	vertical-align: middle
}

.tg .tg-qbk8 {
	border-color: inherit;
	font-weight: bold;
	text-align: center;
	vertical-align: middle
}

.tg .tg-qbk7 {
	border-color: inherit;
	font-weight: bold;
	vertical-align: middle
}

.tg .tg-i8mc {
	border-color: inherit;
	background-color: #efefef;
	font-size: 18px;
	font-weight: bold;
	text-align: center;
	vertical-align: top
}

.tg .tg-nnwx {
	border-color: inherit;
	font-size: 18px;
	font-weight: bold;
	text-align: center;
	vertical-align: middle
}

.tg .tg-7btt {
	border-color: inherit;
	font-weight: bold;
	text-align: center;
	vertical-align: top
}

.tg .tg-0pky {
	border-color: inherit;
	text-align: left;
	vertical-align: top
}

.tg .tg-0lax {
	text-align: left;
	vertical-align: top
}

</style>

<script type="text/javascript">

window.onload = function () {

    $('#downPDF').on('click', function() {
        window.print();
    });
    
    const queryString = window.location.search;
    const urlParams = new URLSearchParams(queryString);

    // qrantRequestCd 값 가져오기
    const entrManageNo = urlParams.get('entrManageNo');
    console.log("entrManageNo확인: ", entrManageNo);

    //전표 입력
    let data = {
        entrManageNo: entrManageNo
    };
    console.log("data확인: ", data);

    $.ajax({
        url: "/cbs/quar/quarChitPaper",
        data: JSON.stringify(data),
        contentType: "application/json",
        type: "post",
        dataType: "json",
        success: function (result) {
            console.log("quarChitPaper 가져온 값 확인: ", result);
            console.log("quarChitPaper 가져온 값 확인: ", result.length);

            // 중복을 확인하고 count 값을 증가시키는 작업
            let thingNmCounts = {};
            result.forEach(function (item) {
                if (thingNmCounts[item.thingNm]) {
                    thingNmCounts[item.thingNm]++;
                } else {
                    thingNmCounts[item.thingNm] = 1;
                }
            });

            let str = "";
            let totalPrice = 0;

            //정보 테이블
            document.getElementById('allQrantJudg').innerText = result[0].allQrantJudg;
            document.getElementById('bizrno').innerText = result[0].bizrno;
            document.getElementById('charger').innerText = result[0].charger;
            document.getElementById('entrprsNm').innerText = result[0].entrprsNm;
            document.getElementById('inspctAgen').innerText = result[0].inspctAgen;
            document.getElementById('mfrcRealmSe').innerText = result[0].mfrcRealmSe;
            document.getElementById('qrantIemNo').innerText = result[0].qrantIemNo;
            //document.getElementById('qrantSe').innerText = result[0].qrantSe;
            document.getElementById('reprsntAdres').innerText = result[0].reprsntAdres;
            document.getElementById('userNm').innerText = result[0].userNm;
            document.getElementById('entrManageNo').innerText = result[0].entrManageNo;
            document.getElementById('inspctDate').innerText = result[0].inspctDate;

            
            
            // 중복값을 제거하여 각 항목에 대해 하나의 데이터만 표시
            let uniqueResults = result.filter((item, index, self) =>
                index === self.findIndex((t) => (
                    t.thingNm === item.thingNm
                ))
            );

            uniqueResults.forEach(function (item) {
                // qrantSe에 따라 qrant 값을 설정
                let bPrice = 0;
                let bCount = 0;
                let qrant = "";
                if (item.qrantSe == 1) {
                    qrant = "정밀검사";
                } else if (item.qrantSe == 2) {
                    qrant = "관능검사";
                } else if (item.qrantSe == 3) {
                    qrant = "임상검사";
                } else if (item.qrantSe == 12) {
                    qrant = "정밀검사, 관능검사";
                    bPrice = 100000;
                    bCount = 1;
                } else if (item.qrantSe == 13) {
                    qrant = "정밀검사, 임상검사";
                    bPrice = 100000;
                    bCount = 1;
                } else if (item.qrantSe == 123) {
                    qrant = "정밀검사, 관능검사, 임상검사";
                    bPrice = 200000;
                    bCount = 2;
                } else if (item.qrantSe == 23) {
                    qrant = "관능검사, 임상검사";
                    bPrice = 100000;
                    bCount = 1;
                };

                let price = 100000; // 단가
                let allPrice = price+bPrice; // 여러항목 단가
                let count = thingNmCounts[item.thingNm]; // 중복된 항목의 count 값
                let allCount = count+bCount;
                let totalPriceForItem = allCount * price; // 각 항목의 공급가액
                totalPrice += totalPriceForItem; // 총 공급가액 누적

                str += "<tr>";
                str += "<td class='tg-qbk8'>" + item.thingNm + "</td>";
                str += "<td class='tg-qbk7' colspan='5'>" + qrant + "</td>";
                str += "<td class='tg-qbk8' colspan='2'>" + allCount + "</td>";
                str += "<td class='tg-qbk8'colspan='2'>" + price.toLocaleString() + "</td>";
                str += "<td class='tg-qbk8' colspan='3'>" + totalPriceForItem.toLocaleString() + "</td>";
                str += "<td class='tg-0pky' colspan='3'></td>";
                str += "</tr>";
            });

            // 화면에 표시
            $("#tbody").html(str);
            document.getElementById('allPrice').innerHTML = totalPrice.toLocaleString(); // 총 공급가액

        }
    });
}


</script>
<nav style="margin-bottom: 10px; margin-left: 20px;">
	<div style="text-align: right;">
		<button type="button" id="downPDF" style="height: auto;"><svg class="svg-inline—fa fa-print" aria-hidden="true" focusable="false" data-prefix="fas" data-icon="print" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" data-fa-i2svg=""><path fill="currentColor" d="M448 192H64C28.65 192 0 220.7 0 256v96c0 17.67 14.33 32 32 32h32v96c0 17.67 14.33 32 32 32h320c17.67 0 32-14.33 32-32v-96h32c17.67 0 32-14.33 32-32V256C512 220.7 483.3 192 448 192zM384 448H128v-96h256V448zM432 296c-13.25 0-24-10.75-24-24c0-13.27 10.75-24 24-24s24 10.73 24 24C456 285.3 445.3 296 432 296zM128 64h229.5L384 90.51V160h64V77.25c0-8.484-3.375-16.62-9.375-22.62l-45.25-45.25C387.4 3.375 379.2 0 370.8 0H96C78.34 0 64 14.33 64 32v128h64V64z"></path></svg></button>
	</div>
</nav>
	<div>
		<table class="tg" style="table-layout: fixed; width: 1054px">
			<colgroup>
				<col style="width: 70px">
				<col style="width: 44px">
				<col style="width: 55px">
				<col style="width: 26px">
				<col style="width: 112px">
				<col style="width: 72px">
				<col style="width: 26px">
				<col style="width: 90px">
				<col style="width: 84px">
				<col style="width: 44px">
				<col style="width: 65px">
				<col style="width: 23px">
				<col style="width: 149px">
				<col style="width: 74px">
				<col style="width: 120px">
			</colgroup>
			<thead>
				<tr>
					<th class="tg-nnwx" colspan="15" rowspan="2">검사 검역 계산서</th>
				</tr>
				<tr>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="tg-qbk9" rowspan="4">공급자</td>
					<td class="tg-qbk9" colspan="2">검역 번호</td>
					<td class="tg-qbk8" colspan="5" id="qrantIemNo"></td>
					<td class="tg-qbk9" rowspan="4">공급받는자</td>
					<td class="tg-qbk9" colspan="3">사업자 등록번호</td>
					<td class="tg-qbk8" colspan="4" id="bizrno"></td>
				</tr>
				<tr>
					<td class="tg-qbk9" colspan="2">검역장소</td>
					<td class="tg-qbk8" colspan="2" id="inspctAgen"></td>
					<td class="tg-qbk9">성명<br>(검역자)
					</td>
					<td class="tg-qbk8" colspan="2" id="userNm"></td>
					<td class="tg-qbk9" colspan="3">상호</td>
					<td class="tg-qbk8" colspan="2" id="entrprsNm"></td>
					<td class="tg-qbk9">성명<br>(담당자)
					</td>
					<td class="tg-qbk8" id="charger"></td>
				</tr>
				<tr>
					<td class="tg-qbk9" colspan="2">검역 일시</td>
					<td class="tg-qbk8" colspan="5" id="inspctDate"></td>
					<td class="tg-qbk9" colspan="3">사업장 주소</td>
					<td class="tg-qbk8" colspan="4" id="reprsntAdres"></td>
				</tr>
				<tr>
					<td class="tg-qbk9" colspan="2">검사 판정</td>
					<td class="tg-qbk8" colspan="5" id="allQrantJudg"></td>
					<td class="tg-qbk9" colspan="3">통관관리번호</td>
					<td class="tg-qbk8" colspan="2" id="entrManageNo"></td>
					<td class="tg-qbk9">종목</td>
					<td class="tg-qbk8" id="mfrcRealmSe"></td>
				</tr>
				<tr>
					<td class="tg-qbk9">품목</td>
					<td class="tg-qbk9" colspan="5">검사 항목</td>
					<td class="tg-qbk9" colspan="2">수량</td>
					<td class="tg-qbk9" colspan="2">단가(VAT포함)</td>
					<td class="tg-qbk9" colspan="3">공급가액(VAT포함)</td>
					<td class="tg-qbk9" colspan="3">비고</td>
				</tr>
			<tbody id="tbody">
				<!-- 데이터 들어갈 곳 -->

			</tbody>
			<tr>
				<td class="tg-i8mc" colspan="12">합 계 금 액(VAT포함)</td>
				<td class="tg-qbk9" colspan="3" >입금처</td>
			</tr>
			<tr>
				<td class="tg-qbk8" colspan="12" value="합계금액" id="allPrice"></td>
				<td class="tg-qbk8" colspan="3" >하나은행 110-324-234623</td>
			</tr>
			</tbody>
		</table>
	</div>
</body>
</html>