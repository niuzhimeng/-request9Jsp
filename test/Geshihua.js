const {WeaInput} = ecCom;
const {Pagination} = antd;
const {Card} = antd;

class perTest0222 extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            myData: []
        };
    }

    componentDidMount() {
        let options = {
            url: '/data.json',
            method: 'GET'
        };
        window.weaJs.callApi(options).then((res) => {
            console.log('res', res.data.length);
            if (res.flag) {
                this.setState({
                    myData: res.data
                })
            }

        });
    }

    render() {
        console.log('数据长度： ', this.state.myData.length)
        let res = this.state.myData.map((item, index) =>
            <div style={{width: 300, float: 'left', marginLeft: 30, marginTop: 10}}>
                <Card title={item.name}>
                    <MyTx key={index}
                          url={"http://localhost:8080/photo.jpg"}
                          name={item.name}
                          department={item.department}
                          job={item.job}
                          telephone={item.telephone}
                          photo={item.photo}
                    />
                </Card>
            </div>
        )

        return (
            <div style={{float: 'left', width: '500', whitSpace: 'pre-wrap', marginLeft: 130, marginRight: 50}}>
                {res}
                <div style={{width: '100%', float: 'left', marginLeft: 350, marginTop: 20}}>
                    <Pagination defaultCurrent={1} total={50}/>
                </div>
            </div>

        )
    }
}

//发布模块CusEle，作为模块${appId}的子模块
ecodeSDK.setCom('${appId}', 'perTest0222', perTest0222);