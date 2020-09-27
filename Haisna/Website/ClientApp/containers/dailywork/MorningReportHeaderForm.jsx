import React from 'react';
import PropTypes from 'prop-types';
import { Field, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import styled from 'styled-components';
import Checkbox from '../../components/control/CheckBox';
import Button from '../../components/control/Button';
import MessageBanner from '../../components/MessageBanner';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDownCourse from '../../components/control/dropdown/DropDownCourse';

import { getMorningReportRequest, checkCslDate, initializeMorningReport } from '../../modules/dailywork/morningReportModule';

const formName = 'MorningReportHeader';

const WrapperButton = styled.div`
margin-bottom: 10px;
`;

class MorningReportHeader extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // 画面を初期化
  componentDidMount() {
    const { onLoad, conditions } = this.props;
    // onLoadアクションの引数として渡す
    onLoad(conditions);
  }

  // コンポーネントがアンマウントされる前に1回だけ呼ばれる処理
  componentWillUnmount() {
    // 一覧を初期化する
    const { initializeList } = this.props;
    initializeList();
  }

  // 検索実行
  handleSubmit(values) {
    const { onSubmit } = this.props;
    // onSubmitアクションの引数として渡す
    onSubmit(values);
  }

  render() {
    const { handleSubmit, message } = this.props;
    return (
      <div>
        <MessageBanner messages={message} />
        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <Button type="submit" value="検索" /><WrapperButton />
          <FieldGroup itemWidth={80}>
            <FieldSet>
              <FieldItem>受診日</FieldItem>
              <Field name="csldate" component={DatePicker} />
            </FieldSet>
            <FieldSet>
              <FieldItem>コース</FieldItem>
              <Field name="cscd" component={DropDownCourse} addblank blankname="すべて" />
              <div style={{ marginLeft: '5px' }} >
                <Field component={Checkbox} name="needunreceipt" label="当日ＩＤ未発番状態のデータも表示対象とする" checkedValue />
              </div>
            </FieldSet>
          </FieldGroup>
        </form>
      </div>
    );
  }
}
const MorningReportHeaderForm = reduxForm({
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ
  enableReinitialize: true,

})(MorningReportHeader);

MorningReportHeader.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  initializeList: PropTypes.func.isRequired,
  conditions: PropTypes.shape().isRequired,
};

const mapStateToProps = (state) => ({
  initialValues: state.app.dailywork.morningReport.morningReport.conditions,
  message: state.app.dailywork.morningReport.morningReport.message,
  // 可視状態
  conditions: state.app.dailywork.morningReport.morningReport.conditions,
});

const mapDispatchToProps = (dispatch) => ({
  // 画面を初期化
  onLoad: (params) => {
    dispatch(getMorningReportRequest(params));
  },
  onSubmit: (params) => {
    // 受診日チェック
    if (params.csldate === undefined || params.csldate === null) {
      dispatch(checkCslDate());
      return;
    }
    dispatch(getMorningReportRequest(params));
  },
  initializeList: () => {
    dispatch(initializeMorningReport());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(MorningReportHeaderForm);

