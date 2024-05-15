<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@	page import="java.util.List"%>
<%@	page import="com.team4.cbs.main.vo.ScheduleVO"%>
<!DOCTYPE html>
<html>
<script type="text/javascript" src="/resources/js/jquery-3.6.4.min.js"></script>	
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.css">
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/main.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.1/moment.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.10.1/locales-all.js"></script>

<head>
<script>
	$(document).ready(
					function() {
						$(function() {
							var request = $.ajax({
								url : "/cbs/calendarUpdate", // 값 불러오기
								method : "GET",
								dataType : "json"
							});
							request.done(function(data) {
										console.log(data); // log로 데이터 찍어주기
										var calendarEl = document.getElementById('calendar');
										calendar = new FullCalendar.Calendar(
												calendarEl,
												{
													height : '700px',
													slotMinTime : '06:00', // Day 캘린더에서 시작 시간
													slotMaxTime : '23:00', // Day 캘린더에서 종료 시간
													// 헤더에 표시할 툴바
													headerToolbar : {
														left : 'prev,next,today',
														center : 'title',
														right : 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
													},
													initialView : 'dayGridMonth', // 초기 로드 될 때 보이는 캘린더 화면 (기본 설정 : 달)
													navLinks : true, // 날짜를 선택하면 Day 캘린더나 Week 캘린더로 링크
													editable : true, 
													selectable : true, // 달력 일자 드래그 설정 가능
													droppable : true, // 드래그 앤 드롭
													events : data,
													locale : 'ko', // 한국어 설정
													
													select : function(arg) { // 캘린더에서 드래그로 이벤트를 생성할 수 있다
														var title = prompt('일정을 입력해주세요.');
														if (title) {
															calendar.addEvent({
																		title : title,
																		start : arg.start,
																		end : arg.end,
																		allDay : arg.allDay
																	})
														} else {
															location.reload(); // 새로고침
															return;
														}
														var events = new Array(); // Json 데이터를 받기 위한 배열 선언
														var obj = new Object(); // Json을 담기 위해 Object 선언
														obj.title = title;
														obj.start = arg.start; // 시작
														obj.end = arg.end; // 끝
														events.push(obj);
														var jsondata = JSON.stringify(events);
														console.log(jsondata);
														$(function saveData(
																jsonData) {
															$.ajax({
																	url : "/cbs/addevent",
																	method : "POST",
																	dataType : "json",
																	data : JSON.stringify(events),
																	contentType : "application/json;charset:utf-8"
																	})
															calendar.unselect()
														});
													},
													// 드래그로 이벤트 수정하기
													eventDrop : function(info) {
														if (confirm("'" + info.event.title + "'일정을 수정하시겠습니까?")) {
															var events = new Array(); // Json 데이터를 받기 위한 배열 선언
															var obj = new Object();
															obj.title = info.event._def.title;
															obj.start = info.event._instance.range.start;
															obj.end = info.event._instance.range.end;
															obj.oldTitle = info.oldEvent._def.title;
															obj.oldStart = info.oldEvent._instance.range.start;
															obj.oldEnd = info.oldEvent._instance.range.end;
															events.push(obj);
															console.log(events);
														} else {
															location.reload(); // 새로 고침
														}
														$(function modifyData() {
															$.ajax({
																	url : "/cbs/modify",
																	method : "post",
																	dataType : "json",
																	data : JSON.stringify(events),
																	contentType : "application/json;charset:utf-8"
															})
														})
													},
														
													eventResize : function(info) {
														console.log(info);
														if (confirm("'" + info.event.title + "'의 시간을 변경하시겠습니까?'")) {
															var events = new Array(); // JSON 데이터를 받기 위한 배열
															var obj = new Object();
															obj.title = info.event._def.title;
															obj.start = info.event._instance.range.start;
															obj.end = info.event._instance.range.end;
															obj.oldTitle = info.oldEvent._def.title;
															obj.oldStart = info.oldEvent._instance.range.start;
															obj.oldEnd = info.oldEvent._instance.range.end;
															events.push(obj);
															console.log(events);
														} else {
															location.reload(); // 새로고침
														}
														$(function modifyData() {
															$.ajax({
																	url : "/cbs/modify",
																	method : "post",
																	dataType : "json",
																	data : JSON.stringify(events),
																	contentType : "application/json;charset:utf-8"
																	})
														})
													},
													
													// 이벤트 선택해서 삭제하기
													eventClick : function(info) {
														if (confirm("'"	+ info.event.title + "'을 삭제하시겠습니까?")) {
															// 확인 클릭 시
															info.event.remove();
														}
														console.log(info.event);
														var events = new Array(); // JSON 데이터를 받기 위한 배열 선언
														var obj = new Object();
														obj.title = info.event._def.title;
														obj.start = info.event._instance.range.start;
														events.push(obj);
														console.log(events);
														$(function deleteData() {
															$.ajax({
																	url : "/cbs/delete",
																	method : "post",
																	dataType : "json",
																	data : JSON.stringify(events),
																	contentType : "application/json;charset:utf-8"
															})
														})
													}
												});
										calendar.render();
							});
						});
					});
</script>
<title>Full Calendar</title>
</head>
<body>
	<div id="calendar"></div>
</body>
</html>
