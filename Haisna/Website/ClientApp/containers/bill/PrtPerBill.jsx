import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Field, reduxForm } from 'redux-form';

import PageLayout from '../../layouts/PageLayout';
import MessageBanner from '../../components/MessageBanner';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';

import Table from '../../components/Table';
import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import Radio from '../../components/control/Radio';
import TextBox from '../../components/control/TextBox';
import DropDown from '../../components/control/dropdown/DropDown';

import { getPrtPerBillRequest, updatePrtPerBillRequest } from '../../modules/bill/perBillModule';

// 敬称配列の作成
const keishouItems = [{ value: '様', name: '様' }, { value: '御中', name: '御中' }];

const formName = 'prtPerBill';

class PrtPerBill extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleSaveprt = this.handleSaveprt.bind(this);
    this.handlePrint = this.handlePrint.bind(this);
  }

  componentDidMount() {
    const { onLoad, match } = this.props;

    onLoad(match.params);
  }

  // 保存ボタン押下時
  handleSubmit(values) {
    const { onSubmit } = this.props;

    const act = 'save';

    onSubmit({ values, act });
  }

  // 保存印刷ボタン押下時
  handleSaveprt(values) {
    const { onSubmit } = this.props;

    const act = 'saveprt';

    onSubmit({ values, act });
  }

  // 印刷ボタンを押下時
  handlePrint() {
    // TODO
    // 印刷処理
  }

  render() {
    const { handleSubmit, message, prtBillItem } = this.props;

    return (
      <PageLayout title="領収書・請求書印刷">
        <MessageBanner messages={message} />
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <Button type="submit" value="保　存" />
          <Button onClick={handleSubmit((values) => this.handleSaveprt(values))} value="保存印刷" />
          <Button onClick={this.handlePrint} value="印　刷" />

          <Table style={{ width: '910px' }}>
            <thead>
              <tr>
                <th />
                <th>宛名</th>
                <th>敬称</th>
              </tr>
            </thead>
            <tbody>
              {prtBillItem && prtBillItem.map((rec, index) => (
                <tr key={rec.key}>
                  <td><Label>{rec.item}</Label></td>
                  <td><Field name={`billName${index + 1}`} component={TextBox} style={{ width: 350 }} /></td>
                  <td><Field name={`keishou${index + 1}`} component={DropDown} items={keishouItems} /></td>
                </tr>
              ))}
            </tbody>
          </Table>

          <div style={{ marginTop: '20px' }}>
            <FieldGroup itemWidth={90}>
              <FieldSet>
                <FieldItem>印刷</FieldItem>
                <Field component={Radio} name="prtKbn" checkedValue="1" label="領収書印刷" />
                <Field component={Radio} name="prtKbn" checkedValue="0" label="請求書印刷" />
              </FieldSet>
            </FieldGroup>
          </div>
        </form>
      </PageLayout>
    );
  }
}

const PrtPerBillForm = reduxForm({
  form: formName,
})(PrtPerBill);

PrtPerBill.propTypes = {
  match: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  prtBillItem: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onLoad: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  message: state.app.bill.perBill.prtPerBill.message,
  prtBillItem: state.app.bill.perBill.prtPerBill.prtBillItem,
});

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    // 請求書情報を取得
    dispatch(getPrtPerBillRequest(params));
  },
  onSubmit: (data) => {
    dispatch(updatePrtPerBillRequest(data));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(PrtPerBillForm);
