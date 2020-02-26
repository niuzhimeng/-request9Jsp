// 根据多选框控制字段显隐
<script type="text/javascript">
    let fxqd3 = WfForm.convertFieldNameToId("fxqd3"); // 多选框

    // 第一块
    let lsxs = WfForm.convertFieldNameToId("lsxs");
    let tcl = WfForm.convertFieldNameToId("tcl");
    let jcjga = WfForm.convertFieldNameToId("jcjga");
    let jssla = WfForm.convertFieldNameToId("jssla");
    let qt15 = WfForm.convertFieldNameToId("qt15");
    let qt17 = WfForm.convertFieldNameToId("qt17");

    // 第二块
    let pfs = WfForm.convertFieldNameToId("pfs");
    let tcl1 = WfForm.convertFieldNameToId("tcl1");
    let jcjgb = WfForm.convertFieldNameToId("jcjgb");
    let jsslb = WfForm.convertFieldNameToId("jsslb");
    let qt16 = WfForm.convertFieldNameToId("qt16");
    let qt18 = WfForm.convertFieldNameToId("qt18");

    // a
    let ikcyxfya = WfForm.convertFieldNameToId("ikcyxfya");
    let iizkjea = WfForm.convertFieldNameToId("iizkjea");
    let iiithjea = WfForm.convertFieldNameToId("iiithjea");
    let ivzzsjea = WfForm.convertFieldNameToId("ivzzsjea");

    // b
    let ikcyxfyb = WfForm.convertFieldNameToId("ikcyxfyb");
    let iizkjeb = WfForm.convertFieldNameToId("iizkjeb");
    let iiithjeb = WfForm.convertFieldNameToId("iiithjeb");
    let ivzzsjeb = WfForm.convertFieldNameToId("ivzzsjeb");

    let na = WfForm.convertFieldNameToId("na");
    // c
    let ithjec = WfForm.convertFieldNameToId("ithjec");
    let iizzsjec = WfForm.convertFieldNameToId("iizzsjec");

    jQuery(document).ready(function () {
        WfForm.bindFieldChangeEvent(na, function (obj, id, value) {
            if (value === '0') {
                WfForm.changeFieldAttr(ithjec, 3);
                WfForm.changeFieldAttr(iizzsjec, 3);
            } else if (value === '1') {
                WfForm.changeFieldAttr(ithjec, 2);
                WfForm.changeFieldAttr(iizzsjec, 2);
            }
        });
        WfForm.bindFieldChangeEvent(fxqd3, function (obj, id, value) {
            if (value === '0' || value === '2' || value === '0,2' || value === '2,0') {
                oneBianJi();
                aBiTian();

                twoYinCang();
                bBianJi();
            } else if (value === '1') {
                oneYinCang();
                aBianJi();

                twoBianJi();
                bBiTian();
            } else if (value.length === 5 || (value.length === 3 && value.indexOf('1') > -1)) {
                oneBianJi();
                aBiTian();

                twoBianJi();
                bBiTian();
            }
        });
    });

    function twoBianJi() {
        // 第二块编辑
        WfForm.changeFieldAttr(pfs, 2);
        WfForm.changeFieldAttr(tcl1, 2);
        WfForm.changeFieldAttr(jcjgb, 2);
        WfForm.changeFieldAttr(jsslb, 2);
        WfForm.changeFieldAttr(qt16, 2);
        WfForm.changeFieldAttr(qt18, 2);
    }

    function twoYinCang() {
        // 第二块隐藏
        WfForm.changeFieldAttr(pfs, 4);
        WfForm.changeFieldAttr(tcl1, 4);
        WfForm.changeFieldAttr(jcjgb, 4);
        WfForm.changeFieldAttr(jsslb, 4);
        WfForm.changeFieldAttr(qt16, 4);
        WfForm.changeFieldAttr(qt18, 4);
    }

    function oneBianJi() {
        // 第一块编辑
        WfForm.changeFieldAttr(lsxs, 2);
        WfForm.changeFieldAttr(tcl, 2);
        WfForm.changeFieldAttr(jcjga, 2);
        WfForm.changeFieldAttr(jssla, 2);
        WfForm.changeFieldAttr(qt15, 2);
        WfForm.changeFieldAttr(qt17, 2);
    }

    function oneYinCang() {
        // 第一块隐藏
        WfForm.changeFieldAttr(lsxs, 4);
        WfForm.changeFieldAttr(tcl, 4);
        WfForm.changeFieldAttr(jcjga, 4);
        WfForm.changeFieldAttr(jssla, 4);
        WfForm.changeFieldAttr(qt15, 4);
        WfForm.changeFieldAttr(qt17, 4);
    }

    function aBiTian() {
        // a部分字段必填
        WfForm.changeFieldAttr(ikcyxfya, 3);
        WfForm.changeFieldAttr(iizkjea, 3);
        WfForm.changeFieldAttr(iiithjea, 3);
        WfForm.changeFieldAttr(ivzzsjea, 3);
    }

    function aBianJi() {
        // a部分字段编辑
        WfForm.changeFieldAttr(ikcyxfya, 2);
        WfForm.changeFieldAttr(iizkjea, 2);
        WfForm.changeFieldAttr(iiithjea, 2);
        WfForm.changeFieldAttr(ivzzsjea, 2);
    }

    function bBiTian() {
        // b部分字段必填
        WfForm.changeFieldAttr(ikcyxfyb, 3);
        WfForm.changeFieldAttr(iizkjeb, 3);
        WfForm.changeFieldAttr(iiithjeb, 3);
        WfForm.changeFieldAttr(ivzzsjeb, 3);
    }

    function bBianJi() {
        // b部分字段编辑
        WfForm.changeFieldAttr(ikcyxfyb, 2);
        WfForm.changeFieldAttr(iizkjeb, 2);
        WfForm.changeFieldAttr(iiithjeb, 2);
        WfForm.changeFieldAttr(ivzzsjeb, 2);
    }

</script>






