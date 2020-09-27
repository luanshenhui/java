import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import { Field, reduxForm } from 'redux-form';
import GuideBase from '../../components/common/GuideBase';
import Button from '../../components/control/Button';
import { FieldGroup, FieldSet, FieldItem, FieldValue } from '../../components/Field';
import MessageBanner from '../../components/MessageBanner';
import TextBox from '../../components/control/TextBox';
import PersonHeader from '../../containers/common/PersonHeader';

import { registerWelComeInfoRequest, closeReceiptFrontDoorGuide } from '../../modules/reserve/consultModule';

const formName = 'ReceiptFrontDoorGuide';

class ReceiptFrontDoorGuide extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // 確定ボタン押下時の処理
  handleSubmit(values) {
    if (values.guidanceno === '' || values.guidanceno === undefined || values.ocrno === '' || values.ocrno === undefined) {
      // eslint-disable-next-line
      alert('ご案内書Ｎｏ、ＯＣＲＮｏとも入力してください。');
      return;
    }
    const { onSerchSubmit, jumpsource, onClose } = this.props;
    const rsvno = values.guidanceno;
    const data = { values, jumpsource, rsvno };
    onSerchSubmit(data);
    onClose();
  }

  render() {
    const { handleSubmit, message, errstauts, data, dayidtxt, comedatetxt, csldatetxt, perid } = this.props;
    return (
      <GuideBase {...this.props} title="受付入力" usePagination={false}>
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
                <lable style={{ width: 50 }}><Link to={`/WebHains/contents/reserve/rsvMain.asp?rsvno=${data.rsvno}`}>{data.rsvno}</Link></lable>
                <FieldItem>当日ＩＤ</FieldItem>
                <lable style={{ width: 70, color: '#ff6600' }}>{dayidtxt}</lable>
                <FieldItem>来院情報</FieldItem>
                <lable style={{ width: 60, color: '#ff6600' }}>{comedatetxt}</lable>
              </FieldSet>
              <FieldSet>
                <FieldItem>コース</FieldItem>
                <lable style={{ width: 110 }}>{data.csname}</lable>
                <FieldItem>受診日</FieldItem>
                <lable style={{ width: 100 }}>{csldatetxt}</lable>
                <FieldItem>予約群</FieldItem>
                <lable style={{ width: 110 }}>{data.rsvgrpname}</lable>
              </FieldSet>
              <FieldSet>
                <PersonHeader perid={perid} />
              </FieldSet>
            </FieldGroup>
          }
        </form>
      </GuideBase>
    );
  }
}

const ReceiptFrontDoorForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(ReceiptFrontDoorGuide);

// propTypesの定義
ReceiptFrontDoorGuide.propTypes = {
  visible: PropTypes.bool.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onSerchSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  jumpsource: PropTypes.string.isRequired,
  errstauts: PropTypes.string.isRequired,
  data: PropTypes.arrayOf(PropTypes.string).isRequired,
  dayidtxt: PropTypes.string.isRequired,
  comedatetxt: PropTypes.string.isRequired,
  csldatetxt: PropTypes.string.isRequired,
  perid: PropTypes.string.isRequired,
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
  initialValues: {
    guidanceno: state.app.reserve.consult.receiptFrontDoorGuide.guidanceno,
    ocrno: state.app.reserve.consult.receiptFrontDoorGuide.ocrno,
  },
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
});

export default connect(mapStateToProps, mapDispatchToProps)(ReceiptFrontDoorForm);
