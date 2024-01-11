<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>Olivia</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">    
	<!-- Bootstrap CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
   <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            background-image: url('https://source.unsplash.com/1920x1080/?orange'); /* 무료 배경 이미지 사용 (Unsplash) */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            margin: 0; /* body의 기본 margin 제거 */
        }

        #loginContainer {
            background-color: rgba(255, 255, 255, 0.8); /* 투명도 조절 가능한 배경 색상 */
            padding: 40px; /* 패딩 크기 조정 */
            border-radius: 10px;
            text-align: left; /* 텍스트 정렬 왼쪽으로 변경 */
            width: 400px; /* 컨테이너 너비 조정 */
        }

        #loginContainer h2 {
            text-align: center; /* 제목 가운데 정렬 */
        }

        #loginContainer label {
            font-weight: bold;
            display: block;
            margin-bottom: 5px;
        }

        #loginContainer input {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            box-sizing: border-box;
        }

        #loginContainer button {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>	
</head>
<body>
    <main id="loginContainer">
        <h2>로그인</h2>
        <form action="/loginProcess" method="post">
            <div class="mb-3">
                <label for="username">사용자명</label>
                <input type="text" id="username" name="username" placeholder="사용자명을 입력하세요" required>
            </div>
            <div class="mb-3">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
            </div>
            <button type="submit">로그인</button>
        </form>
        <c:if test="error">
        	<div>invalid username or password</div>
        </c:if>
    </main>

</body>
</html>