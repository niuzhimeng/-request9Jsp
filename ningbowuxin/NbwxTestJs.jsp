// 合同申请流程
<script type="text/javascript">
    // 门店提报类型
    var mdtblx = 'field6852';
    // 门店涉及出稿方
    var mdsjcgf = 'field6855';

    // 装修设计补贴
    var zxsjbt = 'field7097';
    // 装饰/陈列补贴
    var zxclbt = 'field7098';
    // 店铺启动补贴
    var dpqdbt = 'field7099';
    // 合计
    var hj = 'field7100';

    jQuery(document).ready(function () {
        WfForm.bindFieldChangeEvent(mdtblx + ',' + mdsjcgf, function (obj, id, value) {
            var mdtblxVal = WfForm.getFieldValue(mdtblx);
            var mdsjcgfVal = WfForm.getFieldValue(mdsjcgf);

            if (mdtblxVal == '1') {
                // 迷你店
                if (mdsjcgfVal == '0') {
                    // rlex设计
                    WfForm.changeFieldValue(zxsjbt, {value: "4000"});
                    WfForm.changeFieldValue(zxclbt, {value: "5000"});
                    WfForm.changeFieldValue(dpqdbt, {value: "2000"});
                    WfForm.changeFieldValue(hj, {value: "11000"});
                } else {
                    // 自主设计
                    WfForm.changeFieldValue(zxsjbt, {value: "2000"});
                    WfForm.changeFieldValue(zxclbt, {value: "5000"});
                    WfForm.changeFieldValue(dpqdbt, {value: "2000"});
                    WfForm.changeFieldValue(hj, {value: "9000"});
                }
            } else if (mdtblxVal == '0') {
                // 标准店
                WfForm.changeFieldValue(zxsjbt, {value: "10000"});
                WfForm.changeFieldValue(zxclbt, {value: "20000"});
                WfForm.changeFieldValue(dpqdbt, {value: "5000"});
                WfForm.changeFieldValue(hj, {value: "35000"});
            } else {
                // 清空
                WfForm.changeFieldValue(zxsjbt, {value: "0"});
                WfForm.changeFieldValue(zxclbt, {value: "0"});
                WfForm.changeFieldValue(dpqdbt, {value: "0"});
                WfForm.changeFieldValue(hj, {value: "0"});
            }
        });

        document.getElementById('field6756').onblur = function () {
            var phone = document.getElementById('field6756').value;
            if (!(/^\d+$/.test(phone))) {
                alert("只能填写数字");
            }
        }
    });
</script>


// 完美门店流程， 带出省、区县、城市
<script type="text/javascript">
    // 门店编号
    var mdbh = 'field7115';
    // 省份
    var sf = 'field7112';
    // 城市
    var cs = 'field7113';
    // 区县
    var qx = 'field7114';

    jQuery(document).ready(function () {
        WfForm.bindFieldChangeEvent(mdbh, function (obj, id, value) {
            $.ajax({
                type: "post",
                url: "/workflow/request/ningbowuxin/WanMeiMenDianBack.jsp",
                cache: false,
                async: false,
                data: {"myJson": value},
                success: function (myData) {
                    myData = myData.replace(/\s+/g, "");
                    var returnJson = JSON.parse(myData);
                    WfForm.changeFieldValue(sf, {
                        value: returnJson.sf,
                        specialobj: [{id: returnJson.sf, name: returnJson.sfVal}]
                    });
                    WfForm.changeFieldValue(cs, {
                        value: returnJson.cs,
                        specialobj: [{id: returnJson.cs, name: returnJson.csVal}]
                    });
                    WfForm.changeFieldValue(qx, {
                        value: returnJson.qx,
                        specialobj: [{id: returnJson.qx, name: returnJson.qxVal}]
                    });
                }

            });
        });
    })
</script>











