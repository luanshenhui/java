import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { reduxForm, getFormValues } from 'redux-form';
import styled from 'styled-components';
import moment from 'moment';

import { registerMergePerbillRequest } from '../../modules/bill/perBillModule';
import BulletedLabel from '../../components/control/BulletedLabel';
import Table from '../../components/Table';
import Button from '../../components/control/Button';
import MoneyFormat from './MoneyFormat';

const Font = styled.span`
  font-weight: bold;
  font-size: 10%;
`;

const formName = 'mergePerBill2Form';

class MergePerBillGuide2 extends React.Component {
  constructor(props) {
    super(props);

    this.handleSaveClick = this.handleSaveClick.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
  }

  handleSaveClick() {
    const { onSavePerBill, retPerBillList } = this.props;
    onSavePerBill(retPerBillList);
  }

  // 「戻る」ボタンクリック時の処理
  handleCancelClick() {
    const { onBack } = this.props;
    onBack();
  }

  render() {
    const { retPerBillList } = this.props;

    return (
      <div>
        <Button onClick={() => this.handleSaveClick()} value="確定" />
        <Button onClick={this.handleCancelClick} value="戻る" />
        <BulletedLabel>統合したい請求書を選択してください。</BulletedLabel>
        <Table>
          <thead>
            <tr>
              <th>個人ＩＤ</th>
              <th>氏名</th>
              <th>金額</th>
              <th>調整金額</th>
              <th>税額</th>
              <th>調整税額</th>
              <th>請求金額</th>
              <th>請求書No.</th>
            </tr>
          </thead>
          <tbody>
            {retPerBillList && retPerBillList.map((rec) => (
              <tr key={rec.key}>
                <td>{rec.perId}</td>
                <td><Font>{rec.lastKName} {rec.firstKName}</Font><br />{rec.lastName} {rec.firstName}</td>
                <td><MoneyFormat money={rec.price} /></td>
                <td><MoneyFormat money={rec.editPrice} /></td>
                <td><MoneyFormat money={rec.taxPrice} /></td>
                <td><MoneyFormat money={rec.editTax} /></td>
                <td><strong><MoneyFormat money={rec.priceTotal} /></strong></td>
                <td>{moment(rec.dmdDate).format('YYYYMMDD')}{`0000${rec.billSeq}`.slice(-5)}{rec.branchNo}</td>
              </tr>
            ))
            }
          </tbody>
        </Table>
      </div>
    );
  }
}

const MergePerBillGuide2Form = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  enableReinitialize: true,
})(MergePerBillGuide2);

// propTypesの定義
MergePerBillGuide2.propTypes = {
  // stateと紐付けされた項目
  retPerBillList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onSavePerBill: PropTypes.func.isRequired,
  onBack: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    retPerBillList: state.app.bill.perBill.mergeGuide.retPerBillList,
  };
};

// componentのプロパティとして紐付けるアクション(action)の定義
const mapDispatchToProps = (dispatch) => ({
  onSavePerBill: (retPerBillList) => {
    dispatch(registerMergePerbillRequest({ retPerBillList }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(MergePerBillGuide2Form);
