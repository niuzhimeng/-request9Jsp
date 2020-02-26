// 项目立项申请流程
<script type="text/javascript">
    // 项目名称
    var xmmc = 'field8092';
    // 是否车场
    var sfcc = 'field9538';
    // 开票客户
    var kpkh = 'field8186';
    // 车场
    var cc = 'field10005';
    // 具体项目名称
    var jtxmmc = 'field8708';
    // 产品线信息
    var cpxxx = 'field10006';

    // 日期
    var rq3 = '10521';
    var rq4 = '8952';

    // 项目类型
    var xmlx = 'field8094';
    // 总金额
    var zje = 'field8954';
    // 项目分类
    var xmfl = 'field8095';

    jQuery(document).ready(function () {
        firstAdd('detail_3', rq3);
        firstAdd('detail_4', rq4);
        setTimeout("sysFun()", 500);

        WfForm.bindFieldChangeEvent(xmfl + ',' + sfcc + ',' + kpkh + ',' + cc + ',' + jtxmmc + ',' + cpxxx, function (obj, id, value) {
            var xmlxVal = WfForm.getFieldValue(xmlx);
            var sfccVal = WfForm.getFieldValue(sfcc);
            var kpkhVal = WfForm.getFieldValue(kpkh);
            var ccVal = WfForm.getFieldValue(cc);
            var jtxmmcVal = WfForm.getFieldValue(jtxmmc);
            var cpxxxVal = WfForm.getFieldValue(cpxxx);
            var ifFull;
            if (Number(xmlxVal) === 0) {
                // 客户交付类
                if (Number(sfccVal) === 1) {
                    ifFull = ifFull9(sfccVal, kpkhVal, ccVal, jtxmmcVal, cpxxxVal);
                    myFuZhi(ifFull, kpkhVal, ccVal, jtxmmcVal, cpxxxVal);
                } else {
                    ifFull = ifFull9(sfccVal, ccVal, jtxmmcVal, cpxxxVal);
                    myFuZhi(ifFull, ccVal, jtxmmcVal, cpxxxVal);
                }
            } else if (Number(xmlxVal) === 1) {
                // 内部研发类
                ifFull = ifFull9(jtxmmcVal, cpxxxVal);
                myFuZhi(ifFull, jtxmmcVal, cpxxxVal);
            }
        });

        // 项目分类赋值
        WfForm.bindFieldChangeEvent(xmlx + ',' + zje, function (obj, id, value) {
            var xmlxVal = WfForm.getFieldValue(xmlx);
            var zjeVal = WfForm.getFieldValue(zje);
            if (Number(xmlxVal) === 0) {
                // 客户交付类
                if (Number(zjeVal) >= 3000000) {
                    WfForm.changeFieldValue(xmfl, {value: "0"});
                } else if (Number(zjeVal) >= 1000000) {
                    WfForm.changeFieldValue(xmfl, {value: "1"});
                } else {
                    WfForm.changeFieldValue(xmfl, {value: "2"});
                }
            } else {
                if (Number(zjeVal) >= 500000) {
                    WfForm.changeFieldValue(xmfl, {value: "3"});
                } else {
                    WfForm.changeFieldValue(xmfl, {value: "4"});
                }
            }
        });
    });

    /**
     * 给项目名称赋值
     */
    function myFuZhi(ifFull) {
        if (arguments[0]) {
            var endName = "";
            for (var i = 1; i < arguments.length; i++) {
                endName += arguments[i] + '/';
            }
            endName = endName.substring(0, endName.length - 1);
            WfForm.changeFieldValue(xmmc, {value: endName});
        }
    }

    /**
     * 判断五个字段是否填全
     */
    function ifFull9() {
        var flag = true;
        for (var i = 0; i < arguments.length; i++) {
            if (arguments[i] == null || arguments[i] == '' || arguments[i] == undefined) {
                flag = false;
                break;
            }
        }
        return flag;
    }

    /**
     * 手动新增或删除明细行
     */
    function sysFun() {
        // 绑定新增明细事件
        _customAddFun2 = function (addIndexStr) {
            newAdd('detail_3', rq3, addIndexStr);
        };

        _customAddFun3 = function (addIndexStr) {
            newAdd('detail_4', rq4, addIndexStr);
        };

        // 绑定删除事件
        _customDelFun2 = function () {
            setTimeout("deleteRow(rq3, 'detail_3')", 1000);
        };

        _customDelFun3 = function () {
            setTimeout("deleteRow(rq4, 'detail_4')", 1000);
        };
    }

    /**
     * 删除某行时，日期重新递增赋值
     */
    function deleteRow(zdName, detailName) {
        var mxh = WfForm.getDetailAllRowIndexStr(detailName).split(',');
        var date = getCurrDate();
        //得到开始年
        var sYear = date.getFullYear();
        var len = mxh.length;
        for (var j = 0; j < len; j++) {
            var addDate = (sYear + j);
            WfForm.changeFieldValue("field" + zdName + "_" + mxh[j], {
                value: addDate,
                specialobj: [{id: addDate.toString(), name: addDate.toString()}]
            });
        }
    }

    /**
     * 新增行日期递增
     */
    function newAdd(detailName, zdName, addIndexStr) {
        var mxh = WfForm.getDetailAllRowIndexStr(detailName).split(',');
        var lastValue = WfForm.getFieldValue("field" + zdName + "_" + mxh[mxh.length - 2]);
        if (lastValue == null || lastValue == '' || lastValue == undefined) {
            var date = getCurrDate();
            //得到开始年
            var sYear = date.getFullYear() + 0;
            WfForm.changeFieldValue("field" + zdName + "_" + addIndexStr, {
                value: sYear,
                specialobj: [{id: sYear.toString(), name: sYear.toString()}]
            });
        } else {
            var newVar = Number(lastValue) + 1;
            WfForm.changeFieldValue("field" + zdName + "_" + addIndexStr, {
                value: newVar,
                specialobj: [{id: newVar.toString(), name: newVar.toString()}]
            });
        }
    }

    /**
     * 初始化插入五行明细
     */
    function firstAdd(detailName, zdName) {
        var mxh = WfForm.getDetailAllRowIndexStr(detailName);
        if (mxh != '') {
            return;
        }
        var date = getCurrDate();
        //得到开始年
        var sYear = date.getFullYear();

        for (var i = 0; i < 5; i++) {
            WfForm.addDetailRow(detailName);
        }
        for (var j = 0; j < 5; j++) {
            var addDate = (sYear + j);
            WfForm.changeFieldValue("field" + zdName + "_" + j, {
                value: addDate,
                specialobj: [{id: addDate.toString(), name: addDate.toString()}]
            });
        }
    }

    /**
     * 获取当前日期
     */
    function getCurrDate() {
        var myDate = "";
        jQuery.ajax({
            async: false,
            type: "POST",
            success: function (result, status, xhr) {
                myDate = new Date(xhr.getResponseHeader("Date"));
            }
        });
        return myDate;
    }

</script>


