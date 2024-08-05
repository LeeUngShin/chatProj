<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<HTML>
	<head>
		<meta charset="utf8">
		<style>
			#contentsTable{
				width : 350px;
				border-spacing: 0 10px;
				border : solid blue 3px;
				padding : 20px;
				margin-bottom : 20px;
				border-radius : 20px;
				display: block;
				height: 600px;
				overflow-y: scroll;
			}
			

			.nickname{
				width:80px;
				text-align : center;
				border : solid black 2px;
			}
			
			.you{
				padding-left : 10px;			
			}
			
			.me{
				text-align : right;
			}
			
		</style>
	</head>
	<body onload="loginCheck()">
		<script>
			//let TimerCheck;
			var nickname = '<%= (String)session.getAttribute("nickname")%>'
			
			
			function loginCheck(){
				console.log(nickname);
				//TimerCheck = setInterval(getList, 2000);
				if(nickname != "" && nickname != "null"){
					document.getElementById("loginbox").style.display = "none";
					document.getElementById("contentsdiv").style.display = "block";
					getList();
				}else{
					document.getElementById("loginbox").style.display = "block";
					document.getElementById("contentsdiv").style.display = "none";
					document.getElementById("userNickname").focus();
				}
			}
			
			function goLogin(){
				var inputNickname = document.getElementById("userNickname").value;
				document.getElementById("userNickname").value = "";
				var loginFormData = new Object();
				loginFormData.nickname = inputNickname;
				var loginJsonData = JSON.stringify(loginFormData);
				console.log(loginJsonData);
				fetch("http://192.168.22.18:8080/login",{
					method : "POST",
					headers:{
						"Content-Type" : "application/json"
					},
					body : loginJsonData,
				})
				.then(response => {
					if(!response.ok){
						throw new Error("Network response was not ok");
					}
					return response.json();
				})
				.then(data =>{
					if(data.result == "fail"){
						alert("로그인 실패");
					}
					else{
						alert("로그인 성공");
						console.log(data);
						nickname = inputNickname;
						console.log(nickname);
						document.getElementById("loginbox").style.display = "none";
						document.getElementById("contentsdiv").style.display = "block";
						getList();
					}
				});
			}
			
			function goLogout(){
				fetch("http://192.168.22.18:8080/logout")
				.then(response=>{
					nickname="";
					document.getElementById("loginbox").style.display = "block";
					document.getElementById("contentsdiv").style.display = "none";	
					document.getElementById("nickname").focus();
				});
			}
			
			
			function goAdd(){
				var contents = document.getElementById("contents").value;
				const payload = new FormData();
				payload.append("contents", contents);
				fetch("http://192.168.22.18:8080/add",{
					method : "POST",
					body : payload,
				})
				.then((response)=>{
					document.getElementById("contents").value = "";
					getList();				  
				});
			}
			
			
			
			function keyPress(event, menunum) {
				if(event.keyCode == 13) {
					if(menunum == 1) {
						goAdd();	
					} else {
						goLogin();
					}					
				}
			}	
			
			function getList() {
				fetch("http://192.168.22.18:8080/list")
					.then((response) => response.json())
					.then((data) => {
						
						document.getElementById("contentsTable").innerHTML = 
							"";

						for(index = 0; index < data.length; index++) {
							
							var delText = "";
							var modText = "";

							if(data[index].nickname == nickname) {
								delText = "<a href='javascript:goDel(" + data[index].id + ")'>[X]</a>";
								modText = "<a href='javascript:goMod(" + data[index].id + ")'>[V]</a>";
								document.getElementById("contentsTable").innerHTML += 
									"		<tr>" + 
									"			<td>" + '' + "</td>" +
									"			<td class='me'>" + data[index].message + "</td>" +
									"			<td>" + delText + "</td>" +
									"			<td>" + modText + "</td>" +  
									"		</tr>";
								
						    }
							else{
								document.getElementById("contentsTable").innerHTML +=
									"		<tr>" + 
									"			<td class='nickname'>" + data[index].nickname + "</td>" +
									"			<td class='you'>" + data[index].message + "</td>" +
									"		</tr>";
							}
						
					 	 }	
					  	document.getElementById("contents").focus();
					});
			}
			
			function goDel(id){
				if(confirm("정말 삭제하시겠습니까?")){
					fetch("http://192.168.22.18:8080/del?id=" + id,{
						method : "POST",
					})
					.then((response) => response.json())
					.then((data) => {
						if(data.result == "fail"){
							alert("삭제실패");
						}
						else{
							getList();
						}
						
					});
				}
			}
			
			function goMod(id){
				var modifyText = prompt("수정내용");
				const payload = new FormData();
				payload.append("contents", modifyText);
				console.log(payload);
				fetch("http://192.168.22.18:8080/mod?id=" + id,{
					method : "POST",
					body : payload,
				})
				.then((response) =>{
					getList();
				});
			}
			
		</script>
		
	
		<div id="loginbox">
			<input ytpe="text" id = "userNickname"> 
			<input type="button" value="시작" onclick="javascript:goLogin()">
		</div>
		
		
		<div id="contentsdiv">
			<table id="contentsTable">
			</table>
			
			<table>			
				<tr>
					<td colspan=3>
						<input type="text" id="contents"  onKeydown="javascript:keyPress(event, 1)" >
						<input type="button" value="입력" onclick="javascript:goAdd()">
						<input type="button" value="로그아웃" onclick="javascript:goLogout()">
					</td>
				</tr>				
			</table>
		</div>
	</body>
</HTML>