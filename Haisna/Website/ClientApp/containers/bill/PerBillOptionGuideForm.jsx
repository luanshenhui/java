import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import styled from 'styled-components';

import MessageBanner from '../../components/MessageBanner';
import Radio from '../../components/control/Radio';
import CheckBox from '../../components/control/CheckBox';
import Button from '../../components/control/Button';
import GuideBase from '../../components/common/GuideBase';
import Table from '../../components/Table';
import LabelCourseWebColor from '../../components/control/label/LabelCourseWebColor';

import { updateConsultOptionRequest, closePerbillOptionGuide } from '../../modules/bill/perBillModule';

const Wrapper = styled.div`
  height: 400px;
  margin-top: 10px;
  overflow-y: auto;
`;

const formName = 'perBillOptionGuide';

const createOptionList = (data) => {
  const res = [];
  let strPrevOptCd = ''; // 直前レコードのオプションコード
  let strElementType;// オプション選択用のエレメント種別

  for (let i = 0; i < data.length; i += 1) {
    // 受付画面表示対象であれば
    if (data[i].hiderpt == null) {
      // 直前レコードとオプションコードが異なる場合
      if (data[i].optcd !== strPrevOptCd) {
        // まず編集するエレメントを設定する(枝番数が１つならチェックボックス、さもなくばラジオボタン選択)
        strElementType = data[i].branchcount === 1 ? CheckBox : Radio;
      }

      // 直前レコードとオプションコードが異なる場合はセパレータを編集
      if (strPrevOptCd !== '' && data[i].optcd !== strPrevOptCd) {
        res.push(<tr key={i}><td colSpan="4" /></tr>);
      }

      const td1 = <td><Field component={strElementType} name={`opt_${data[i].optcd}`} checkedValue={data[i].optbranchno} /></td>;
      const td2 = <td>{data[i].optcd}-{data[i].optbranchno}:</td>;
      const td3 = <td><LabelCourseWebColor webcolor={data[i].setcolor} />{data[i].optname}</td>;
      const td4 = <td style={{ textAlign: 'center' }}>{data[i].addcondition === 1 && '任意'}</td>;
      res.push(<tr key={`${data[i].optcd}-${data[i].optbranchno}`}>{td1}{td2}{td3}{td4}</tr>);

      // 現レコードのオプションコードを退避
      strPrevOptCd = data[i].optcd;
    }
  }

  return res;
};

class PerBillOptionGuide extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // 登録
  handleSubmit(values) {
    const { rsvno, ctrptcd, consultoptionall, onSubmit } = this.props;
    onSubmit({ rsvno, ctrptcd, consultoptionall, values });
  }

  render() {
    const { handleSubmit, message, consultoptionall } = this.props;

    return (
      <GuideBase {...this.props} title="受診セット変更" usePagination >
        <MessageBanner messages={message} />
        <Wrapper>
          <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
            <div>
              <Button type="submit" value="保存" />
            </div>
            <Table>
              <thead>
                <tr>
                  <th colSpan="3" style={{ textAlign: 'center' }}>検査セット名</th>
                  <th>受診条件</th>
                </tr>
              </thead>
              <tbody>
                {consultoptionall && createOptionList(consultoptionall)}
              </tbody>
            </Table>
          </form>
        </Wrapper>
      </GuideBase>
    );
  }
}

const PerBillOptionGuideForm = reduxForm({
  form: formName,
})(PerBillOptionGuide);

// propTypesの定義
PerBillOptionGuide.propTypes = {
  rsvno: PropTypes.number.isRequired,
  ctrptcd: PropTypes.number.isRequired,
  consultoptionall: PropTypes.arrayOf(PropTypes.shape()),
  visible: PropTypes.bool.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
};

// defaultPropsの定義
PerBillOptionGuide.defaultProps = {
  consultoptionall: [],
};

const mapStateToProps = (state) => ({
  rsvno: state.app.bill.perBill.perbilloptionGuide.rsvno,
  ctrptcd: state.app.bill.perBill.perbilloptionGuide.ctrptcd,
  consultoptionall: state.app.bill.perBill.perbilloptionGuide.consultoptionall,
  visible: state.app.bill.perBill.perbilloptionGuide.visible,
  message: state.app.bill.perBill.perbilloptionGuide.message,
});

const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closePerbillOptionGuide());
  },
  onSubmit: (data) => dispatch(updateConsultOptionRequest(data)),
});

export default connect(mapStateToProps, mapDispatchToProps)(PerBillOptionGuideForm);
