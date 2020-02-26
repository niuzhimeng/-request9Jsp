
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_item" class="weaver.conn.RecordSet" scope="page" />
<%
int fieldid = Util.getIntValue(request.getParameter("fieldid"), 0);
int childfieldid = Util.getIntValue(request.getParameter("childfieldid"), 0);
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int selectedfieldid = Util.getIntValue(request.getParameter("selectedfieldid"), 0);
int uploadType = Util.getIntValue(request.getParameter("uploadType"), 0);
int selectvalue = Util.getIntValue(request.getParameter("selectvalue"), -1);
String childvalue = Util.null2String(request.getParameter("childvalue"));
int isdetail = Util.getIntValue(request.getParameter("isdetail"), 0);
int rowindex = Util.getIntValue(request.getParameter("rowindex"), 0);
int ismobile =  Util.getIntValue(request.getParameter("ismobile"), 0);
//明细行号
int rumnum =  Util.getIntValue(request.getParameter("rowindex"), -1);
String fieldname = "";
if(isdetail == 0){
    fieldname = "field"+childfieldid;
}else{
    fieldname = "field"+childfieldid+"_"+rowindex;
}

//表示形式
int showtype = 1;
//排列方式
int fieldshowtypes =1;

if (isbill == 0) {
    if(isdetail == 0){
        rs.executeQuery("select type,fieldshowtypes from workflow_formdict where id=?", childfieldid);
    }else{
        rs.executeQuery("select type,fieldshowtypes from workflow_formdictdetail where id=?", childfieldid);
    }
} else {
    rs.executeQuery("select type,fieldshowtypes from workflow_billfield where id=?", childfieldid);
}
if(rs.next()){
    showtype = Util.getIntValue(rs.getString("type"), 1);
    fieldshowtypes = Util.getIntValue(rs.getString("fieldshowtypes"), 1);
}
//System.out.println("fieldid = " + fieldid);
%>
<script type="text/javascript">
var childfieldValue = "<%=childvalue%>";
if(childfieldValue == ""){
    childfieldValue = parent.jQuery("#<%=fieldname%>").val();
}
//var childfieldValue = "";
if(childfieldValue=="-1"){
    try{
        if (window.parent.$G) {
            childfieldValue = window.parent.$G("<%=fieldname%>").value;
        } else {
            childfieldValue = window.parent.document.getElementById("<%=fieldname%>").value;
        }
    }catch(e){
        childfieldValue = "";
    }
    if(childfieldValue==null || childfieldValue=="-1"){
        childfieldValue = "";
    }
}
var selectfield = null;
function getSelectField(){
    try{
        <%if(showtype == 1){%>
        var elements = window.parent.document.getElementsByName("<%=fieldname%>");
        //alert(elements.length);
        if(elements.length==null){
            selectfield = elements;
        }else{
            for(var i=0; i<elements.length; i++) {
                try{
                    //alert(elements[i]);
                    //alert(elements[i].name);
                    //alert(elements[i].tagName);
                    if(elements[i].tagName=="SELECT"){
                        selectfield = elements[i];
                        break;
                    }
                }catch(e){}
            }
        }
        <%}else{%>
        selectfield = parent.jQuery("#<%=fieldname%>")[0];
        <%}%>
    }catch(e){}
    //alert(selectfield);
    //alert(selectfield.tagName);
}
function onChangeSelectField_All(){
    try{
        //var selectfield = window.parent.document.getElementById("<%=fieldname%>");
        if(selectfield != null){
            <%if(showtype == 1){%>
            parent.jQuery("#<%=fieldname%>").get(0).options.length = 0;
            parent.jQuery("#<%=fieldname%>").append("<option></option>");
            <%}else{%>
            parent.jQuery("#<%=fieldname%>").parent().find(".radioCheckDiv").html("");
            <%}%>
        }
    }catch(e){}
}
getSelectField();
if(selectfield != null){
    onChangeSelectField_All();
}
</script>
<%
String sql = "";
String changeSelectJSStr = "";
sql = "select childitemid from workflow_selectitem where fieldid="+fieldid+" and isbill="+isbill+" and selectvalue="+selectvalue;
out.println("<script>if(window.console)console.log('select childitemid from workflow_selectitem where fieldid="+fieldid+" and isbill="+isbill+" and selectvalue="+selectvalue + "')</script>");
rs.execute(sql);
String defaultValue ="";
if(rs.next()){
    String childitemid = Util.null2String(rs.getString("childitemid"));
    if(!"".equals(childitemid.trim())){
        if(!"".equals(childitemid)){
            if(childitemid.indexOf(",")==0){
                childitemid = childitemid.substring(1);
            }
            if(childitemid.endsWith(",")){
                childitemid = childitemid.substring(0, childitemid.length()-1);
            }
            int cx_tmp = 1;
            String fieldhtml = "";
            sql = "select id, selectvalue, selectname, listorder,isdefault from workflow_selectitem where fieldid="+childfieldid+" and isbill="+isbill+" and selectvalue in ("+childitemid+") and ( cancel!=1 or cancel is null) order by listorder, id asc";
            rs_item.execute(sql);
out.println("<script>if(window.console)console.log('sql=====================select id, selectvalue, selectname, listorder from workflow_selectitem where fieldid="+childfieldid+" and isbill="+isbill+" and selectvalue in ("+childitemid+") and ( cancel!=1 or cancel is null) order by listorder, id asc')</script>");

            while(rs_item.next()){
                String selectvalue_tmp = Util.null2String(rs_item.getString("selectvalue"));
                String selectname_tmp = Util.toScreen(rs_item.getString("selectname"), 7);
                if(showtype == 1){
                    changeSelectJSStr += ("selectfield.options["+cx_tmp+"] = new Option(\""+selectname_tmp+"\", \""+selectvalue_tmp+"\");\n");
                    if("y".equals(Util.null2String(rs_item.getString("isdefault")))){
                        defaultValue = selectvalue_tmp;
                    }
                }else{
                    //PC端生成的子项
                    if(ismobile == 0){

                        if(fieldshowtypes == 1){
                            fieldhtml += "<div class='selectItemHorizontalDiv'>";
                        }else if(fieldshowtypes == 2){
                            fieldhtml += "<div class='selectItemVerticalDiv'>";
                        }
                        if(showtype == 2){
                            if("y".equals(Util.null2String(rs_item.getString("isdefault")))){
                                if(!defaultValue.equals("")) defaultValue += ",";
                                defaultValue += selectvalue_tmp;
                            }
                            fieldhtml += "<input type='checkbox' value='" + selectvalue_tmp + "'";
                            fieldhtml += " onclick=";
                            fieldhtml += "selectItemCheckChange(this,'" + fieldname.replace("field","") + "');";
                            fieldhtml += " name='" + fieldname + "_" + selectvalue_tmp + "' id='" + fieldname + "_" + selectvalue_tmp + "' ";

                            fieldhtml += " >";
                            fieldhtml += "<label for='" + fieldname + "_" + selectvalue_tmp + "'>" + selectname_tmp + "</label>";
                            fieldhtml += "</div>";
                        }else{
                            if("y".equals(Util.null2String(rs_item.getString("isdefault")))){
                                defaultValue = selectvalue_tmp;
                            }
                            fieldhtml += "<input type='radio' value='" + selectvalue_tmp + "'";
                            fieldhtml += " onclick=";
                            fieldhtml += "selectItemCheckChange(this,'" + fieldname.replace("field","") + "');";
                            fieldhtml += " name='" + fieldname + "_disp' id='" + fieldname + "_" + selectvalue_tmp + "' ";
                            fieldhtml += " >";
                            fieldhtml += "<label for='" + fieldname + "_" + selectvalue_tmp + "'>" + selectname_tmp + "</label>";
                            fieldhtml += "</div>";
                        }
                    }else{
                        //手机端生成的子项
                        fieldhtml += "<div class='selectItemVerticalDiv'>";
                        if(showtype == 2){
                            if("y".equals(Util.null2String(rs_item.getString("isdefault")))){
                                if(!defaultValue.equals("")) defaultValue += ",";
                                defaultValue += selectvalue_tmp;
                            }
                            fieldhtml += "<input type='checkbox' value='" + selectvalue_tmp + "'";
                            fieldhtml += " onclick=";
                            fieldhtml += "selectItemCheckChange(this,'" + fieldname + "');";
                            fieldhtml += " name='" + fieldname + "_" + selectvalue_tmp + "' id='" + fieldname + "_" + selectvalue_tmp + "' ";

                            fieldhtml += " >";
                            fieldhtml += "<label for='" + fieldname + "_" + selectvalue_tmp + "'>" + selectname_tmp + "</label>";
                            fieldhtml += "</div>";
                        }else{
                            if("y".equals(Util.null2String(rs_item.getString("isdefault")))){
                                defaultValue = selectvalue_tmp;
                            }
                            fieldhtml += "<input type='radio' value='" + selectvalue_tmp + "'";
                            fieldhtml += " onclick=";
                            fieldhtml += "selectItemCheckChange(this,'" + fieldname + "');";
                            fieldhtml += " name='" + fieldname + "_disp' id='" + fieldname + "_" + selectvalue_tmp + "' ";
                            fieldhtml += " >";
                            fieldhtml += "<label for='" + fieldname + "_" + selectvalue_tmp + "'>" + selectname_tmp + "</label>";
                            fieldhtml += "</div>";
                        }
                    }
                }
                cx_tmp++;
                changeSelectJSStr += ("parent.jQuery('#" + fieldname + "').parent().find('.radioCheckDiv').html(\"" + fieldhtml + "\");\n");
                if(showtype != 1 &&!defaultValue.equals("")){
                    if (ismobile == 0){
                        changeSelectJSStr += ("parent.jQuery('#" + fieldname + "span').html(\"\");\n");
                    }else{
                        changeSelectJSStr += ("parent.jQuery('#" + fieldname + "_ismandspan').hide();\n");
                    }
                }
            }
        }
    }
}
if(showtype != 1 && defaultValue.equals("") && showtype != 1){
    if (ismobile == 0){
        changeSelectJSStr += ("parent.jQuery('#" + fieldname + "').val(\"" + defaultValue + "\");\n");
        changeSelectJSStr += ("if(parent.jQuery('#" + fieldname + "').attr(\"viewtype\") == 1)parent.jQuery('#" + fieldname + "span').html(\"<img src='/images/BacoError_wev8.gif' align=absmiddle>\");\n");
    }else{
        changeSelectJSStr += ("parent.jQuery('#" + fieldname + "').val(\"" + defaultValue + "\");\n");
        changeSelectJSStr += ("if(parent.jQuery('#" + fieldname + "').attr(\"viewtype\") == 1)parent.jQuery('#" + fieldname + "_ismandspan').show();\n");
    }
}
%>
<script type="text/javascript">
function insertSelect_All(){
    var selectfield = null;
    var hasSelected = false;
    var fieldSpan;
    var viewtype;
    try{
        selectfield = window.parent.document.getElementById("<%=fieldname%>");
        if (window.parent.jQuery) {
            viewtype = window.parent.jQuery(selectfield).attr('viewtype');
        } else {
            viewtype = selectfield.viewtype;
        }
    }catch(e){
        viewtype = "0";
    }
    if(viewtype=="undefined" || viewtype==undefined){
        viewtype = "0";
    }
    try{
        <%
        if(showtype == 1){%>
        parent.jQuery("#<%=fieldname%>").find("option").remove();
        parent.jQuery("#<%=fieldname%>").append("<option></option>");
        <%}else{%>
        //清空子项内容
        parent.jQuery("#<%=fieldname%>").val("");
        parent.jQuery("#<%=fieldname%>").parent().find(".radioCheckDiv").html("");
        <%}
        %>
        <%=changeSelectJSStr%>
        <%if(showtype == 1){%>
        //判断保存的值是否存在列表中
        if(parent.jQuery("#<%=fieldname%>").find("option[value='" + childfieldValue + "']").length <= 0){
            childfieldValue = "";
        }
        <%}
        %>
        if(childfieldValue=="") childfieldValue = '<%=defaultValue%>';
        
        //单选框---------strat
        <%
        if(showtype == 3){
        %>
        //判断已选择value是否存在于列表中
        if(parent.jQuery("input[type='radio'][id^='<%=fieldname%>'][value='"+childfieldValue+"']").not("[id$='d']").length <= 0){
            childfieldValue = '<%=defaultValue%>';
        }
        parent.jQuery("input[type='radio'][id^='<%=fieldname%>']").each(function(){
            parent.jQuery(this).attr("viewtype",viewtype);
            if(childfieldValue == this.value){
                if(!this.checked){
                    if('<%=ismobile%>' != '1' || '<%=isdetail %>' != '1'){
                        parent.jQuery(this).trigger("click");
                    }else{
                        //防止明细编辑区域收缩
                        var tronclickStr = parent.jQuery("#<%=childfieldid+""+rowindex%>").parent().parent().attr("onclick");
                        parent.jQuery("#<%=childfieldid+""+rowindex%>").parent().parent().attr("onclick","");
                        parent.jQuery(this).trigger("click");
                        parent.jQuery("#<%=childfieldid+""+rowindex%>").parent().parent().attr("onclick",tronclickStr);
                    }
                }
            }
            if(parent.jQuery("#<%=fieldname%>").attr('__disabled') == 1){
                parent.jQuery(this).attr("disabled","disabled");
                parent.jQuery("#<%=fieldname%>").val(childfieldValue);
            }
        });
        if('<%=ismobile%>' != '1'){
            parent.jQuery("#<%=fieldname%>").parent().find(".radioCheckDiv").jNice();
            parent.jQuery("#<%=fieldname%>").trigger("change");
        }
        if('<%=ismobile%>' == '1' && '<%=isdetail %>' != '1'){
            parent.jQuery("#<%=fieldname%>").trigger("change");
        }
        <%}%>
        //复选框---------strat
        <%
        if(showtype == 2){
        %>
        parent.jQuery("input[type='checkbox'][id^='<%=fieldname%>_']").not("[id$='d']").each(function(){
            parent.jQuery(this).attr("viewtype",viewtype);
            if(("," + childfieldValue + ",").indexOf("," + this.value + ",") >= 0){
                hasSelected = true;
                var new_className;
                var old_className=this.nextSibling.className;
                if(old_className.indexOf("disabled")>-1) new_className=old_className+" jNiceChecked_disabled";
                 else new_className=old_className+" jNiceChecked";
                 this.checked=true;
                 this.nextSibling.className=new_className;
                if(parent.jQuery("#<%=fieldname%>").val() == ""){
                    parent.jQuery("#<%=fieldname%>").val(this.value);
                }else if(("," + parent.jQuery("#<%=fieldname%>").val() + ",").indexOf("," + this.value + ",") == -1){
                    parent.jQuery("#<%=fieldname%>").val(parent.jQuery("#<%=fieldname%>").val() + "," + this.value);
                }
                parent.jQuery("#<%=fieldname%>span").html("");
            }
            if(parent.jQuery("#<%=fieldname%>").attr('__disabled') == 1){
                parent.jQuery(this).attr("disabled","disabled");
                parent.jQuery("#<%=fieldname%>").val(childfieldValue);
            }
        });
        if('<%=ismobile%>' != '1'){
            parent.jQuery("#<%=fieldname%>").parent().find(".radioCheckDiv").jNice();
        }
        <%}
        %>
        
        //if(childfieldValue!=null && childfieldValue!=""){
            try{
                if('<%=ismobile%>' == '1'){
                    fieldSpan = window.parent.document.getElementById("<%=fieldname%>_ismandspan");
                }else{
                    fieldSpan = window.parent.document.getElementById("<%=fieldname%>span");
                }
                
                <%
                if(showtype == 1){
                %>
                for(var i=selectfield.length-1; i>=0; i--){
                    if (selectfield.options[i] != null){
                        var value_tmp = selectfield.options[i].value;
                        if(value_tmp==childfieldValue){
                            selectfield.options[i].selected = true;
                            if('<%=ismobile%>' == '1' && '<%=isdetail %>' == '1'){
                              selectfield.options[i].setAttribute("selected","selected");
                            }
                            hasSelected = true;
                            if('<%=ismobile%>' == '1'){
                                parent.jQuery(fieldSpan).hide();
                            }else{
                                fieldSpan.innerHTML = "";
                            }
                            break;
                        }
                    }
                }
			    if(hasSelected==false && viewtype=="1" && parent.jQuery(window.parent.document.getElementById("<%=fieldname%>")).parent().is(":visible")){
			        try{
			            if('<%=ismobile%>' == '1'){
			              fieldSpan = window.parent.document.getElementById("<%=fieldname%>_ismandspan");
			            }else{
			              fieldSpan = window.parent.document.getElementById("<%=fieldname%>span");
			            }
                        if('<%=ismobile%>' == '1'){
                            parent.jQuery(fieldSpan).show();
                        }else{
                            fieldSpan.innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
                        }
			        }catch(e){if(window.console) console.log(e)}
			    }
			    
			    //选择项触发onchange事件
			    var selectObj = parent.jQuery("#<%=fieldname%>");
			    var onchangeStr = selectObj.attr('onchange');
			    if(onchangeStr&&onchangeStr!=""){
			        var selObj = selectObj.get(0);
			        if (selObj.fireEvent){
			            selObj.fireEvent('onchange');
			        }else{
			            selObj.onchange();
			        }
			    }
                var onblurStr = selectObj.attr('onblur');
                if(onblurStr&&onblurStr!=""){
                    var selObj = selectObj.get(0);
                    if (selObj.fireEvent){
                        selObj.fireEvent('onblur');
                    }else{
                        selObj.onblur();
                    }
                }
                <%}else if(ismobile == 1){%>
                //手机端控制必填
                if(parent.jQuery("#<%=fieldname%>_ismandfield").val() == '<%=fieldname%>' && parent.jQuery("#<%=fieldname%>").val() === ""){
                    parent.jQuery("#<%=fieldname%>_ismandspan").show();
                    <%if(isdetail == 1){%>
                    //明细编辑区域控制必填
                    if(parent.jQuery("#<%=fieldname%>_d_ismandspan").length > 0){
                        parent.jQuery("#<%=fieldname%>_d_ismandspan").show();
                    }
                    <%}%>
                }else{
                    parent.jQuery("#<%=fieldname%>_ismandspan").hide();
                    <%if(isdetail == 1){%>
                    //明细编辑区域控制必填
                    if(parent.jQuery("#<%=fieldname%>_d_ismandspan").length > 0){
                        parent.jQuery("#<%=fieldname%>_d_ismandspan").hide();
                    }
                    <%}%>
                }
                <%}%>
            }catch(e){if(window.console) console.log(e)}
        //}
    }catch(e){if(window.console) console.log(e)}

}
if(selectfield != null){
    insertSelect_All();
<%
    if(selectedfieldid==childfieldid&&selectedfieldid>0&&uploadType==1){
%>
        try{
            parent.changeMaxUpload('field<%=childfieldid%>');
            parent.reAccesoryChanage();
        }catch(e){
        if(window.console) console.log(e)
        }
<%
    }
%>
}

if('<%=ismobile%>' == '1' && '<%=isdetail %>' == '1'){
   try{
   
      //手机端HTML模板
      try{
        //生成字段编辑TD
        var isshow_id = parent.jQuery("#<%=childfieldid+""+rowindex%>").parent().find("div[id^=isshow]").attr("id").replace("isshow","");
        var fieldinfo = isshow_id.split("_");
        var editTdObj=parent.getEditTd(parent.jQuery("#<%=childfieldid+""+rowindex%>").parent().find("div[name='hiddenEditdiv']"),fieldinfo);
        if(parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").val() === ''){
            parent.jQuery("#<%=childfieldid+""+rowindex%>").parent().find("div[id^=isshow]").html("");
            parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").trigger("change");
        }
        var edithtml=editTdObj.find(".radioCheckDiv").html();
        parent.jQuery("#<%=fieldname%>_tdwrap").find(".radioCheckDiv").html(edithtml);
        if(parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").val() !== "" && parent.jQuery("#field<%=childfieldid+"_"+rowindex%>_" + parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").val() + "_d").length > 0 
           && parent.jQuery("#field<%=childfieldid+"_"+rowindex%>_" + parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").val() + "_d")[0].checked != true){
            parent.jQuery("#field<%=childfieldid+"_"+rowindex%>_" + parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").val() + "_d")[0].checked = true;
        }
        
       }catch(e){
            //手机端普通模板
	      try{
	        //生成字段编辑TD
	        parent.jQuery("#field<%=childfieldid+"_"+rowindex%>_tdwrap").find(".radioCheckDiv").html(parent.getRadioCheckDiv(parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").parent().find(".radioCheckDiv")[0]));
	        if(parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").val() === ''){
	            parent.jQuery("#<%=childfieldid+""+rowindex%>").parent().find("div[id^=isshow]").html("");
                parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").trigger("change");
	        }
	        if(parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").val() !== "" && parent.jQuery("#field<%=childfieldid+"_"+rowindex%>_" + parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").val() + "_d").length > 0 
	           && parent.jQuery("#field<%=childfieldid+"_"+rowindex%>_" + parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").val() + "_d")[0].checked != true){
	            parent.jQuery("#field<%=childfieldid+"_"+rowindex%>_" + parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").val() + "_d")[0].checked = true;
	        }
	       }catch(e){if(window.console) console.log(e)}
	  }
      var  selecteddetail = window.parent.document.getElementById("<%=fieldname%>");
      var  selecteddetaild = window.parent.document.getElementById("<%=fieldname%>_d");
      if(selecteddetaild){
         selecteddetaild.innerHTML =  selecteddetail.innerHTML;
      }
      
      if(window.parent.document.getElementById("<%=fieldname%>_span")){
        window.parent.document.getElementById("<%=fieldname%>_span_d").innerHTML =   window.parent.document.getElementById("<%=fieldname%>_span").innerHTML;
      }
      //编辑手机端显示区域的显示内容
      if(window.parent.document.getElementById("<%=childfieldid%><%=rowindex%>")){
          var detailShowDivName = window.parent.document.getElementById("<%=childfieldid%><%=rowindex%>").value;
          if(window.parent.document.getElementById(detailShowDivName)){
              if(parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").parent().find(".radioCheckDiv").length > 0){
                var radioCheckDiv = parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").parent().find(".radioCheckDiv");
                var showName = "";
                var selectedvalue = parent.jQuery("#field<%=childfieldid+"_"+rowindex%>").val()
                if(radioCheckDiv.find("input[type='radio']").length >0){
                    showName = parent.jQuery("#field<%=childfieldid+"_"+rowindex%>_" + selectedvalue).next().html();
                }else if(radioCheckDiv.find("input[type='checkbox']").length >0){
                    radioCheckDiv.find("input[type='checkbox']").each(function(index,ele){
                        if(("," + selectedvalue + ",").indexOf("," + ele.value + ",") >= 0){
                            showName += "&nbsp;" + parent.jQuery(ele).next().html();
                        }
                    });
                    if(showName.indexOf("&nbsp;") == 0){
                        showName = showName.substring(6);
                    }
                }
                window.parent.document.getElementById(detailShowDivName).innerHTML = showName;
              }else{
                window.parent.document.getElementById(detailShowDivName).innerHTML = selecteddetail.options[selecteddetail.selectedIndex].text;
              }
          }
      }
   }catch(e){if(window.console) console.log(e)}
   
}
try{
     //当明细行时
     <%if(rumnum >= 0){%>
     parent.jQuery("#iframe_<%=fieldid%>_<%=childfieldid%>_<%=rumnum%>").remove();
     <%}else{%>
     parent.jQuery("#iframe_<%=fieldid%>_<%=childfieldid%>_00").remove();
     <%}%>
     
}catch(e){

     //当明细行时
     <%if(rumnum >= 0){%>
     parent.jQuery("#iframe_<%=fieldid%>_<%=childfieldid%>_<%=rumnum%>").html("");
     <%}else{%>
     parent.jQuery("#iframe_<%=fieldid%>_<%=childfieldid%>_00").html("");
     <%}%>
}
</script>
