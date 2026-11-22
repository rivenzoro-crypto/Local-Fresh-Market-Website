<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script
	src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script>
(function(){const b=document.getElementById('sidebarToggle'),s=document.getElementById('sidebar'),o=document.getElementById('adminOverlay');if(b&&s){b.addEventListener('click',()=>{s.classList.toggle('active');if(o)o.classList.toggle('show')});}if(o&&s)o.addEventListener('click',()=>{s.classList.remove('active');o.classList.remove('show')});})();
</script>
