<%--
<%@ page language="java" contentType="text/html; charset=UTF-8" %>--%>
<%--<%@ include file="/systeminfo/init_wev8.jsp" %>--%>
<%!
	public static String $label(int labelId, int languageId){
		return SystemEnv.getHtmlLabelName(labelId, languageId);
	}
%>

<script>
	jQuery(document).ready(function(){
		jQuery.param = function( a ) {
			var s = [];
			var encode = function(str){
				str = escape(str);
				str = str.replace(/\+/g, '%u002B');
				return str;
			};
			function add( key, value ){
				s[ s.length ] = encode(key) + '=' + encode(value);
			};
			if ( jQuery.isArray(a) || a.jquery )
				jQuery.each( a, function(){
					add( this.name, this.value );
				});
			else
				for ( var j in a )
					if ( jQuery.isArray(a[j]) )
						jQuery.each( a[j], function(){
							add( j, this );
						});
					else
						add( j, jQuery.isFunction(a[j]) ? a[j]() : a[j] );
		
			return s.join("&").replace(/%20/g, "+");
		}
	});
</script>