/**
 * @file 会計台帳
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';

// 共通コンポーネント
import DatePicker from '../../components/control/datepicker/DatePicker';
import ReportParameter from '../../components/report/field/ReportParameter';
import ReportForm from '../../containers/report/ReportForm';
import TextBox from '../../components/control/TextBox';

import * as reportFormModule from '../../modules/report/reportFormModule';

// ページタイトル
const TITLE = '予防医療センター会計台帳';

// 初期値の設定
const initialValues = {
  accountdate: moment().format('YYYY/MM/DD'),
  // ファイル名
  fileName: '会計台帳(日誌){date}.xlsx',
};

// フォーム名
const formName = 'AccountBookForm';

// 会計台帳レイアウト
class AccountBook extends React.Component {
  componentDidMount() {
    const { reportFormAction, change } = this.props;
    // 初期値取得
    reportFormAction.getAccountBookDataRequest({
      callback: (payload) => {
        if (payload) {
          change('yobo', payload.freefield1);
          change('hoken', payload.freefield2);
        }
      },
    });
  }

  render() {
    return (
      <div>
        <ReportParameter label="会計日" isRequired>
          <Field name="accountdate" component={DatePicker} />
        </ReportParameter>
        <ReportParameter label="おつり銭（予防医療センター）">
          <Field name="yobo" component={TextBox} />
        </ReportParameter>
        <ReportParameter label="おつり銭（保険診察）">
          <Field name="hoken" component={TextBox} />
        </ReportParameter>
        <div style={{ paddingLeft: 30 }}> 計上日を入力後、【　実行　】ボタンを押下してください。 </div>
      </div>
    );
  }
}

// propTypesを定義
AccountBook.propTypes = {
  reportFormAction: PropTypes.shape().isRequired,
  change: PropTypes.func.isRequired,
};

// redux-formでstate管理するようにする
const AccountBookForm = reduxForm({
  form: formName,
  initialValues,
})(ReportForm(AccountBook, TITLE, 'accountbook'));

const mapDispatchToProps = (dispatch) => ({
  reportFormAction: bindActionCreators(reportFormModule, dispatch),
});

export default connect(() => ({}), mapDispatchToProps)(AccountBookForm);
