<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isErrorPage="true" %>
<section class="content">
	<div class="error-page">
		<h2 class="headline text-warning">errorException</h2>
		<div class="error-content">
			<h3>
				<i class="fas fa-exclamation-triangle text-warning"></i> }
			</h3>
			<p>
				<%=exception.getMessage()%> 만약, 메인으로 이동을 원하면
				<a href="/cbs/home">여기를 클릭해주세요.</a>
			</p>
			<form class="search-form">
				<div class="input-group">
					<input type="text" name="search" class="form-control"
						placeholder="Search">
					<div class="input-group-append">
						<button type="submit" name="submit" class="btn btn-warning">
							<i class="fas fa-search"></i>
						</button>
					</div>
				</div>

			</form>
		</div>

	</div>

</section>