import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Field, reduxForm, getFormValues } from 'redux-form';
import styled from 'styled-components';
import moment from 'moment';

import { dmdDecideAllPriceRequest, initializeDmdDecideAllPrice } from '../../modules/bill/decideAllConsultPriceModule';

import PageLayout from '../../layouts/PageLayout';
import MessageBanner from '../../components/MessageBanner';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Button from '../../components/control/Button';
import Radio from '../../components/control/Radio';
import Label from '../../components/control/Label';
import DatePicker from '../../components/control/datepicker/DatePicker';
import OrgGuide from '../common/OrgGuide';
import ReportOrgParameter from '../report/ReportOrgParameter';


const FontColor = styled.span`
    color: #${(props) => props.color};
`;
const formName = 'DmdDecideAllPrice';
class DmdDecideAllPrice extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleHainsLogClick = this.handleHainsLogClick.bind(this);
  }

  componentDidMount() {
    const { onLoad } = this.props;
    // 画面を初期化
    onLoad();
  }

  // 確定ボタン押下時
  handleSubmit = (values) => {
    const { onSubmit, formValues } = this.props;
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('指定された条件で個人受診金額を再作成します。')) {
      return;
    }
    onSubmit({ ...values });
    formValues.strDate = moment().format('YYYY/MM/DD');
    formValues.endDate = moment().format('YYYY/MM/DD');
    formValues.orgcd1 = '';
    formValues.orgcd2 = '';
    formValues.orgname = '';
  }

  // ログ参照Click時の処理
  handleHainsLogClick() {
    const { history } = this.props;
    const date = moment().format('YYYY/MM/DD');
    const [year, mon, day] = [date.substring(0, 4), date.substring(5, 7), date.substring(8, 10)];
    history.replace(`/contents/preference/hainslog?mode=print&transactionDiv=LOGREMONEY&insDate=${year}%2F${mon}%2F${day}`);
  }

  // 描画処理
  render() {
    const { message, formValues } = this.props;

    return (
      <PageLayout title="個人受診金額再作成">
        <OrgGuide />
        <form>
          <div className="contents frame_content">
            <FieldGroup itemWidth={120}>
              <FieldSet>
                <Button onClick={() => this.handleHainsLogClick()} value="ログ参照" />
                <Button onClick={() => this.handleSubmit(formValues)} value="確 定" />
              </FieldSet>
              <FontColor color="ff6600"><MessageBanner messages={message} /></FontColor>
              <FieldSet>
                <FieldItem>受診日範囲</FieldItem>
                <Field name="strDate" style={{ width: 70 }} component={DatePicker} />
                <Label>～</Label>
                <Field name="endDate" style={{ width: 70 }} component={DatePicker} />
              </FieldSet>
              <FieldSet>
                <FieldItem>団体</FieldItem>
                <ReportOrgParameter {...this.props} formName={formName} orgCd1Field="orgcd1" orgCd2Field="orgcd2" orgNameField="orgname" />
              </FieldSet>
              <FieldSet>
                <FieldItem>実行ログ</FieldItem>
                <Field component={Radio} name="putLog" checkedValue={0} label="開始終了のみ出力" />
                <Label name=""> {}</Label>
                <Field component={Radio} name="putLog" checkedValue={1} label="エラーのみ出力" />
                <Label name="">{} </Label>
                <Field component={Radio} name="putLog" checkedValue={2} label="全て出力" />
              </FieldSet>
            </FieldGroup>
          </div>
        </form>
      </PageLayout>
    );
  }
}


// propTypesの定義
DmdDecideAllPrice.propTypes = {
  history: PropTypes.shape().isRequired,
  formValues: PropTypes.shape(),
  onLoad: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  conditions: PropTypes.shape().isRequired,
  onSubmit: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
};

// defaultPropsの定義
DmdDecideAllPrice.defaultProps = {
  formValues: undefined,
};


const DmdDecideAllPriceForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(DmdDecideAllPrice);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    conditions: state.app.bill.decideAllConsultPrice.dmdDecideAllPrice.conditions,
    message: state.app.bill.decideAllConsultPrice.dmdDecideAllPrice.message,
    initialValues: {
      strDate: state.app.bill.decideAllConsultPrice.dmdDecideAllPrice.conditions.strDate,
      endDate: state.app.bill.decideAllConsultPrice.dmdDecideAllPrice.conditions.endDate,
      putLog: state.app.bill.decideAllConsultPrice.dmdDecideAllPrice.conditions.putLog,
    },
  };
};

const mapDispatchToProps = (dispatch) => ({
  onLoad: () => {
    // 画面を初期化
    dispatch(initializeDmdDecideAllPrice());
  },
  onSubmit: (conditions) => {
    // 確定ボタン押下時
    dispatch(dmdDecideAllPriceRequest({ ...conditions }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(DmdDecideAllPriceForm);
