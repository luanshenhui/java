import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { Field, FieldArray, reduxForm, getFormValues } from 'redux-form';
import { connect } from 'react-redux';
import moment from 'moment';

import { closeCreatePerBillGuide, changeFlg, registerPerbillRequest } from '../../modules/bill/demandModule';
import { FieldGroup, FieldSet, FieldItem, FieldValueList, FieldValue } from '../../components/Field';
import MessageBanner from '../../components/MessageBanner';
import * as contants from '../../constants/common';
import Label from '../../components/control/Label';
import DropDown from '../../components/control/dropdown/DropDown';
import DatePicker from '../../components/control/datepicker/DatePicker';
import Button from '../../components/control/Button';
import GuideBase from '../../components/common/GuideBase';
import PerBillGuideTable from './PerBillGuideTable';

const Color = styled('span')`.
  font-weight: bold;
  color: #FF6600;
`;

const formName = 'createPerBillForm';

class CreatePerBillGuide extends React.Component {
  componentWillReceiveProps() {

  }

  render() {
    const { message, payment, consultmInfo, onClose, onChangeFlg, onCreate, flg, formValues } = this.props;

    let billCount = 0;
    for (let i = 0; i < consultmInfo.length; i += 1) {
      if ((consultmInfo[i].orgcd1 === contants.ORGCD1_PERSON) && (consultmInfo[i].orgcd2 === contants.ORGCD1_PERSON) &&
        ((consultmInfo[i].dmddate === null) || (consultmInfo[i].billseq === null) || (consultmInfo[i].branchno === null))) {
        billCount += 1;
      }
    }
    const piece = [];
    for (let i = 1; i <= billCount; i += 1) {
      piece.push({ value: i, name: i });
    }

    let setSpan = [];
    let setButton;
    let setDate;

    if (flg === 1) {
      setDate = <FieldSet><FieldItem>請求発生日</FieldItem><Field name="cslDate" component={DatePicker} /></FieldSet>;
      setButton = <Button onClick={() => { onCreate(payment.rsvno, formValues, consultmInfo); }} value="確定" />;
    }
    if (billCount > 0) {
      if (flg === 0) {
        setSpan = <span><span style={{ color: '#CC9999' }}>●</span>請求書作成枚数を入力してください。<Field name="dropdownitem" component={DropDown} items={piece} />枚</span>;
        setButton = <Button onClick={() => { onChangeFlg(); }} value="次へ" />;
      }
    } else {
      setSpan = <span><Color>個人請求書は全て作成済。</Color></span>;
    }

    return (
      <GuideBase {...this.props} title={flg === 0 ? '請求書作成（枚数選択）処理' : '請求明細追加'} usePagination={false} >
        <div>
          <MessageBanner messages={message} />
          <FieldSet>
            {setButton}
            <Button onClick={() => { onClose(); }} value="キャンセル" />
          </FieldSet>
          <FieldGroup itemWidth={200}>
            <FieldSet>
              <FieldItem>受診日</FieldItem>
              <Label><Color>{moment(payment && payment.csldate).format('YYYY/MM/DD')}</Color></Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>予約番号</FieldItem>
              <Label><Color>{payment && payment.rsvno}</Color></Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>受診コース</FieldItem>
              <Label><Color>{payment && payment.csname}</Color></Label>
            </FieldSet>
            <FieldSet>
              <FieldItem>{payment && payment.perid}</FieldItem>
              <FieldValueList>
                <FieldValue>
                  <Label>{payment && payment.lastname} {payment && payment.firstname}({payment && payment.lastkname} {payment && payment.firstkname})</Label>
                </FieldValue>
                <FieldValue>
                  <Label>
                    {payment && moment(payment.birth).format('YYYY年M月DD日生')} {Math.round(`${payment && payment.age}`)}歳 {(payment && payment.gender === 1) ? ' 男性' : ' 女性'}
                  </Label>
                </FieldValue>
              </FieldValueList>
            </FieldSet>
            <form>
              {setDate}
              <FieldSet>
                {setSpan}
              </FieldSet>
              { flg === 1 &&
                <FieldArray name="perBill" component={PerBillGuideTable} data={consultmInfo} formValues={formValues} />
              }
            </form>
          </FieldGroup>
        </div>
      </GuideBase>
    );
  }
}

const CreatePerBillGuideForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(CreatePerBillGuide);

// propTypesの定義
CreatePerBillGuide.propTypes = {
  // stateと紐付けされた項目
  visible: PropTypes.bool.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  payment: PropTypes.shape().isRequired,
  consultmInfo: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onClose: PropTypes.func.isRequired,
  onChangeFlg: PropTypes.func.isRequired,
  onCreate: PropTypes.func.isRequired,
  flg: PropTypes.number.isRequired,
  formValues: PropTypes.shape(),
};

CreatePerBillGuide.defaultProps = {
  formValues: undefined,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    message: state.app.bill.demand.perBillGuide.message,
    payment: state.app.bill.demand.perBillGuide.data.payment,
    consultmInfo: state.app.bill.demand.perBillGuide.data.consultmInfo,
    // 可視状態
    visible: state.app.bill.demand.perBillGuide.visible,
    flg: state.app.bill.demand.perBillGuide.flg,
  };
};

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeCreatePerBillGuide());
  },

  onChangeFlg: () => {
    dispatch(changeFlg());
  },

  onCreate: (params, formValues, items) => {
    dispatch(registerPerbillRequest({ params, formValues, items }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(CreatePerBillGuideForm);
