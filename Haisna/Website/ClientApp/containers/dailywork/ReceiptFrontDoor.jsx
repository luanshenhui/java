import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import { Field, reduxForm } from 'redux-form';
import PageLayout from '../../layouts/PageLayout';
import Button from '../../components/control/Button';
import { FieldGroup, FieldSet, FieldItem, FieldValue, FieldValueList } from '../../components/Field';
import MessageBanner from '../../components/MessageBanner';
import TextBox from '../../components/control/TextBox';
import Label from '../../components/control/Label';
import WelComeInfoMenuGuide from './WelComeInfoMenuGuide';


import { registerWelComeInfoRequest, closeReceiptFrontDoorGuide, loadReceiptFrontDoorInfo } from '../../modules/reserve/consultModule';

const formName = 'ReceiptFrontDoorGuide';

class ReceiptFrontDoore extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  componentDidMount() {
    const { onLoad } = this.props;
    // onLoadアクションの引数として渡す
    onLoad();
  }

  // 確定ボタン押下時の処理
  handleSubmit(values) {
    if (values.guidanceno === '' || values.guidanceno === undefined || values.ocrno === '' || values.ocrno === undefined) {
      // eslint-disable-next-line
      alert('ご案内書Ｎｏ、ＯＣＲＮｏとも入力してください。');
      return;
    }
    const { onSerchSubmit } = this.props;
    const jumpsource = 'ReceiptMain';
    const rsvno = values.guidanceno;
    const data = { values, jumpsource, rsvno };
    onSerchSubmit(data);
  }

  render() {
    const { handleSubmit, message, errstauts, data, dayidtxt, comedatetxt, csldatetxt, realagetxt } = this.props;
    return (
      <PageLayout title="受付入力">
        <MessageBanner messages={message} />
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <FieldGroup itemWidth={100}>
            <FieldSet>
              <FieldValue>
                <Button type="submit" value="確 定" />
              </FieldValue>
            </FieldSet>
            <FieldSet>
              <FieldItem >ご案内書Ｎｏ</FieldItem>
              <FieldValue>
                <Field name="guidanceno" component={TextBox} id="guidanceno" maxLength="9" autoFocus="true" style={{ imeMode: 'disabled', width: 100 }} />
              </FieldValue>
            </FieldSet>
            <FieldSet>
              <FieldItem>ＯＣＲＮｏ</FieldItem>
              <FieldValue>
                <Field name="ocrno" component={TextBox} id="ocrno" maxLength="10" style={{ imeMode: 'disabled', width: 110 }} />
              </FieldValue>
            </FieldSet>
          </FieldGroup>
          {(errstauts === 'checkerr') &&
            <FieldGroup itemWidth={75}>
              <FieldSet>
                <FieldItem>予約番号</FieldItem>
                <Label style={{ width: 50 }}><span style={{ color: '#ff6600' }}><b><Link to={`/WebHains/contents/reserve/rsvMain.asp?rsvno=${data.rsvno}`}>{data.rsvno}</Link></b></span></Label>
                <FieldItem>当日ＩＤ</FieldItem>
                <Label><span style={{ color: '#ff6600' }}>{dayidtxt}</span></Label>
                <FieldItem>来院情報</FieldItem>
                <Label><span style={{ color: '#ff6600' }}>{comedatetxt}</span></Label>
              </FieldSet>
              <FieldSet>
                <FieldItem>コース</FieldItem>
                <Label><b>{data.csname}</b></Label>
                <FieldItem>受診日</FieldItem>
                <Label><b>{moment(csldatetxt).format('YYYY/MM/DD')}</b></Label>
                <FieldItem>予約群</FieldItem>
                <Label><b>{data.rsvgrpname}</b></Label>
              </FieldSet>
              <FieldSet>
                <FieldValueList>
                  <FieldValue>
                    {data !== undefined ?
                      <Label>{data !== undefined ? data.perid : ''}
                        <span style={{ fontSize: '16px', fontWeight: 'bold' }} >&nbsp;{data.lastname}&nbsp;{data.firstname}&nbsp;</span>
                        {`(${data.lastkname} ${data.firstkname})`}
                      </Label>
                      :
                      <Label><span style={{ fontSize: '16px', fontWeight: 'bold' }} >&nbsp;&nbsp;&nbsp;</span></Label>
                    }
                    {data !== undefined ?
                      <Label>
                        {data.birthyearshorteraname && data.birthyearshorteraname}
                        {data.birtherayear}&nbsp;{(`${moment(data.birth).format('MM.DD')}生`)}
                        &nbsp;&nbsp;{`${realagetxt}歳`}&nbsp;{data.age ? `(${data.age}歳)` : ''}
                        &nbsp; {data.gendername && data.gendername}&nbsp;{data.gender === 1 ? '男性' : '女性'}
                      </Label>
                      :
                      <Label>(  )   生  歳</Label>
                    }
                  </FieldValue>
                </FieldValueList>
              </FieldSet>
            </FieldGroup>
          }
        </form>
        <WelComeInfoMenuGuide />
      </PageLayout>
    );
  }
}

const ReceiptFrontDoorForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(ReceiptFrontDoore);

// propTypesの定義
ReceiptFrontDoore.propTypes = {
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onSerchSubmit: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  errstauts: PropTypes.string.isRequired,
  data: PropTypes.shape(),
  dayidtxt: PropTypes.string,
  comedatetxt: PropTypes.string,
  csldatetxt: PropTypes.string,
  realagetxt: PropTypes.number,
  onLoad: PropTypes.func.isRequired,
};

ReceiptFrontDoore.defaultProps = {
  dayidtxt: '',
  comedatetxt: '',
  csldatetxt: '',
  realagetxt: 0,
  data: {},
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  visible: state.app.reserve.consult.receiptFrontDoorGuide.visible,
  message: state.app.reserve.consult.receiptFrontDoorGuide.message,
  errstauts: state.app.reserve.consult.receiptFrontDoorGuide.errstauts,
  data: state.app.reserve.consult.receiptFrontDoorGuide.data,
  personInfo: state.app.reserve.consult.receiptFrontDoorGuide.personInfo,
  dayidtxt: state.app.reserve.consult.receiptFrontDoorGuide.dayidtxt,
  comedatetxt: state.app.reserve.consult.receiptFrontDoorGuide.comedatetxt,
  csldatetxt: state.app.reserve.consult.receiptFrontDoorGuide.csldatetxt,
  realagetxt: state.app.reserve.consult.receiptFrontDoorGuide.realagetxt,
});

const mapDispatchToProps = (dispatch) => ({
  // 来院確認処理
  onSerchSubmit: (data) => {
    // 更新を呼び出す
    dispatch(registerWelComeInfoRequest({ data }));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeReceiptFrontDoorGuide());
  },
  // 画面を初期化
  onLoad: () => {
    dispatch(loadReceiptFrontDoorInfo());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(ReceiptFrontDoorForm);
