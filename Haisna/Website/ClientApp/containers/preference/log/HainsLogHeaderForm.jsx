import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import qs from 'qs';

import { withRouter } from 'react-router-dom';
import { Field, reduxForm, blur, getFormValues } from 'redux-form';
import { connect } from 'react-redux';
import ListHeaderFormBase from '../../../components/common/ListHeaderFormBase';
import DropDownFreeValue from '../../../components/control/dropdown/DropDownFreeValue';

import TextBox from '../../../components/control/TextBox';
import Button from '../../../components/control/Button';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import DropDown from '../../../components/control/dropdown/DropDown';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import { getHainsListRequest, initializeHainsList } from '../../../modules/preference/hainsLogModule';


const informationDivItems = [
  { value: '', name: '' },
  { value: 'I', name: '正常' },
  { value: 'W', name: '警告' },
  { value: 'E', name: 'エラー' },
];

const orderByOldItems = [
  { value: '', name: '新しいものから' },
  { value: '1', name: '古いものから' },
];

const limitItems = [
  { value: 50, name: '50行ずつ' },
  { value: 100, name: '100行ずつ' },
  { value: 200, name: '200行ずつ' },
  { value: 300, name: '300行ずつ' },
  { value: false, name: 'すべて' },
];

class hainsLogHeader extends React.Component {
  componentDidMount() {
    const { onSearch, location, onTransactionDivBlur } = this.props;
    const params = qs.parse(location.search, { ignoreQueryPrefix: true });
    if (params.mode) {
      if (params.transactionDiv) {
        onTransactionDivBlur(params);
      }
      onSearch({ ...params });
    }
  }

  render() {
    return (
      <ListHeaderFormBase {...this.props} >
        <FieldGroup>
          <FieldSet>
            <FieldItem>処理名</FieldItem>
            <Field name="transactionDiv" component={DropDownFreeValue} freecd="LOG" namefield="freename" addblank id="transactionDiv" />
            <FieldItem>実行日</FieldItem>
            <Field name="insDate" component={DatePicker} id="insDate" />
            <FieldItem>処理ID</FieldItem>
            <Field name="transactionID" component={TextBox} id="transactionID" style={{ width: 180 }} />
          </FieldSet>
          <FieldSet>
            <FieldItem>検索文字列</FieldItem>
            <Field name="message" component={TextBox} id="message" style={{ width: 280 }} />
            <FieldItem>状態</FieldItem>
            <Field name="informationDiv" component={DropDown} id="informationDiv" items={informationDivItems} />
            <FieldItem>表示</FieldItem>
            <Field name="orderByOld" component={DropDown} id="orderByOld" items={orderByOldItems} />
            <Field name="limit" component={DropDown} id="limit" items={limitItems} />
            <Button type="submit" value="表示" />
          </FieldSet>
        </FieldGroup>
      </ListHeaderFormBase>
    );
  }
}


// propTypesの定義
hainsLogHeader.propTypes = {
  onSearch: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  formValues: PropTypes.shape().isRequired,
  onTransactionDivBlur: PropTypes.func.isRequired,
  location: PropTypes.shape().isRequired,
};

const hainsLogHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'hainsLogHeader',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(hainsLogHeader);


const mapStateToProps = (state) => {
  const formValues = getFormValues('hainsLogHeader')(state);
  return {
    formValues,
    transactionDiv: state.app.preference.hainsLog.hainsLogList.conditions.transactionDiv,
    insDate: state.app.preference.hainsLog.hainsLogList.conditions.insDate,
    transactionID: state.app.preference.hainsLog.hainsLogList.conditions.transactionID,
    message: state.app.preference.hainsLog.hainsLogList.conditions.message,
    informationDiv: state.app.preference.hainsLog.hainsLogList.conditions.informationDiv,
    orderByOld: state.app.preference.hainsLog.hainsLogList.conditions.orderByOld,
    limit: state.app.preference.hainsLog.hainsLogList.conditions.limit,
    initialValues: {
      transactionDiv: state.app.preference.hainsLog.hainsLogList.conditions.transactionDiv,
      insDate: state.app.preference.hainsLog.hainsLogList.conditions.insDate,
      transactionID: state.app.preference.hainsLog.hainsLogList.conditions.transactionID,
      message: state.app.preference.hainsLog.hainsLogList.conditions.message,
      informationDiv: state.app.preference.hainsLog.hainsLogList.conditions.informationDiv,
      orderByOld: state.app.preference.hainsLog.hainsLogList.conditions.orderByOld,
      limit: state.app.preference.hainsLog.hainsLogList.conditions.limit,
    },
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSearch: (conditions) => {
    let params = {};
    if (!conditions.insDate) {
      const insDate = moment().format('YYYY/M/D');
      params = { ...conditions, insDate };
      dispatch(blur('hainsLogHeader', 'insDate', insDate));
    } else {
      params = { ...conditions };
    }
    if (!conditions.limit) {
      const limit = 50;
      const orderByOld = '';
      params = { ...params, limit, orderByOld };
    }
    const startPos = 1;
    dispatch(getHainsListRequest({ startPos, ...params }));
  },
  initializeList: () => {
    dispatch(initializeHainsList());
  },
  onTransactionDivBlur: (params) => {
    dispatch(blur('hainsLogHeader', 'transactionDiv', params.transactionDiv));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(hainsLogHeaderForm));
