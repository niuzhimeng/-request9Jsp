<%
	String __forwardurl__ = request.getParameter("__forwardurl__");
	request.getRequestDispatcher(__forwardurl__).forward(request, response);
	return;
%>