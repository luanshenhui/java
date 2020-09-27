import React from 'react';
import PropTypes from 'prop-types';
import { Field, getFormValues, reduxForm, blur } from 'redux-form';
import { connect } from 'react-redux';

import { getListPerBillRequest } from '../../modules/bill/perBillModule';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import DatePicker from '../../components/control/datepicker/DatePicker';
import Label from '../../components/control/Label';
import CheckBox from '../../components/control/CheckBox';
import Button from '../../components/control/Button';

const formName = 'GdePerBillListHeader';

class GdePerBillListHeader extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // 検索ボタンを押下
  handleSubmit(values) {
    const { onSearch, requestNo, index } = this.props;
    onSearch({ ...values, index, requestNo, sortKind: 0, sortMode: 0, paymentflg: 0, delDisp: 1 });
  }

  render() {
    const { handleSubmit } = this.props;
    return (
      <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
        <div>
          <FieldGroup itemWidth={200}>
            <FieldSet>
              <FieldItem>請求日範囲:</FieldItem>
              <Field name="startDmdDate" component={DatePicker} id="startDmdDate" />
              <Label>～</Label>
              <Field name="endDmdDate" component={DatePicker} id="endDmdDate" />
            </FieldSet>
            <FieldSet>
              <FieldItem>キー:</FieldItem>
              <Field name="key" component="input" type="text" style={{ width: 200 }} />
            </FieldSet>
            <FieldSet>
              <Field name="gde.checkbox" component={CheckBox} checkedValue={1} label="検査未完了者も表示する" id="checkboxName" />
              <Button style={{ marginLeft: '200px' }} type="submit" value="検    索" />
            </FieldSet>
          </FieldGroup>
        </div>
      </form>
    );
  }
}

const GdePerBillListHeaderFrom = reduxForm({
  form: formName,
})(GdePerBillListHeader);

// propTypesの定義
GdePerBillListHeader.propTypes = {
  onSearch: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  requestNo: PropTypes.string.isRequired,
  index: PropTypes.number.isRequired,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    requestNo: state.app.bill.perBill.gdePerBillGuide.requestNo,
    index: state.app.bill.perBill.gdePerBillGuide.index,
  };
};

const mapDispatchToProps = (dispatch) => ({
  onSearch: (params) => {
    dispatch(getListPerBillRequest({ params }));
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(GdePerBillListHeaderFrom);
