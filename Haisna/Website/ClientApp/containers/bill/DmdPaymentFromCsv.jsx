import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import { Field, getFormValues, reduxForm } from 'redux-form';
import PageLayout from '../../layouts/PageLayout';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Button from '../../components/control/Button';
import TextBox from '../../components/control/TextBox';
import File from '../../components/control/File';
import { importCsvRequest, initializePayCsv } from '../../modules/bill/paymentImportCsvModule';
import MessageBanner from '../../components/MessageBanner';

// カスタマイズfontラベル
const Font = styled.span`
    size: ${(props) => props.size};
    color: #${(props) => props.color};
`;
const formName = 'DmdPaymentFromCsv';
class DmdPaymentFromCsv extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleHainsLog = this.handleHainsLog.bind(this);
  }
  componentDidMount() {
    const { initializeDmdPayCsy } = this.props;
    initializeDmdPayCsy();
  }
  // 保存処理
  handleSubmit(values) {
    const { onSubmit } = this.props;
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この内容で一括入金処理を行います。よろしいですか？')) {
      return;
    }
    // 入金情報の作成
    onSubmit(values.csvFile === undefined ? [] : values.csvFile[0], values.startPos);
  }
  // 戻るボタンクリック時の処理
  handleCancelClick() {
    const { history } = this.props;
    history.replace('/contents/demand');
  }
  // ログ参照ボタンクリック時の処理
  handleHainsLog() {
    const { history } = this.props;
    const date = moment().format('YYYY/MM/DD');
    const [year, mon, day] = [date.substring(0, 4), date.substring(5, 7), date.substring(8, 10)];
    history.push(`/contents/preference/hainslog?transactionDiv=LOGPAYCSV&mode=print&insDate=${year}%2F${mon}%2F${day}`);
  }
  // 描画処理
  render() {
    const { handleSubmit, conditions, message, err } = this.props;
    return (
      <PageLayout title="ＣＳＶファイルからの一括入金">
        <form >
          <div>
            <FieldGroup itemWidth={140}>
              <Font color={err === 'err' ? 'FF0000' : 'FF9900'}><MessageBanner messages={message} /></Font>
              <FieldSet>
                <FieldItem>CSVファイル</FieldItem>
                <Field component={File} name="csvFile" id="csvFile" />
              </FieldSet>
              <FieldSet>
                <FieldItem>読み込み開始位置</FieldItem>
                <Field name="startPos" component={TextBox} style={{ width: 80 }} />
              </FieldSet>
              {conditions.fileName !== '' && (
                <FieldSet>
                  <Link to="#"><Font color="006699">取り込み結果付きＣＳＶデータをダウンロードする</Font></Link>
                </FieldSet>
              )}
              <div style={{ paddingTop: 20 }}>
                <Button value="戻 る" onClick={this.handleCancelClick} />
                <Button value="確 定" onClick={handleSubmit((values) => this.handleSubmit(values))} />
              </div>
              <div style={{ paddingTop: 15 }}>
                <Button value="ログ参照" onClick={this.handleHainsLog} />
              </div>
            </FieldGroup>
          </div>
        </form>
      </PageLayout>
    );
  }
}


// propTypesの定義
DmdPaymentFromCsv.propTypes = {
  history: PropTypes.shape().isRequired,
  onSubmit: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  initializeDmdPayCsy: PropTypes.func.isRequired,
  conditions: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  err: PropTypes.string.isRequired,
};
// defaultPropsの定義
DmdPaymentFromCsv.defaultProps = {
};

const DmdPaymentFromCsvForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(DmdPaymentFromCsv);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    data: state.app.bill.paymentImportCsv.dmdPayFromCsv.data,
    message: state.app.bill.paymentImportCsv.dmdPayFromCsv.message,
    conditions: state.app.bill.paymentImportCsv.dmdPayFromCsv.conditions,
    err: state.app.bill.paymentImportCsv.dmdPayFromCsv.err,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  initializeDmdPayCsy: () => {
    dispatch(initializePayCsv());
  },
  // 入金情報の作成
  onSubmit: (files, startPos) => {
    dispatch(importCsvRequest({ files, startPos }));
  },
});
export default connect(mapStateToProps, mapDispatchToProps)(DmdPaymentFromCsvForm);
