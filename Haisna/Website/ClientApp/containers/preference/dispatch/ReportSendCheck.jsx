import React from 'react';
import moment from 'moment';
import { withRouter, NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';

import { reduxForm, Field, getFormValues, blur } from 'redux-form';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import Label from '../../../components/control/Label';
import PageLayout from '../../../layouts/PageLayout';
import TextBox from '../../../components/control/TextBox';
import { getWelComeInfoRequest, initialStateRequest } from '../../../modules/report/reportSendDateModule';
import Table from '../../../components/Table';
import Button from '../../../components/control/Button';

const formName = 'reportSendCheckForm';


const RedHtml = styled.span`
  color: #ff0000;
`;
const OraHtml = styled.span`
  color: #ff6600;
`;


class ReportSendCheck extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }
  componentWillUnmount() {
    const { onClose } = this.props;
    onClose();
  }
  // 表示ボタンクリック時の処理
  handleSubmit(event) {
    const { onSubmit, formValues } = this.props;
    if (event.which === 13) {
      onSubmit({ key: formValues.key, cslDate: formValues.cslDate, act: 'save' });
    }
  }
  handleClick(act) {
    if (act === 'forceins') {
      // 追加挿入
      // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
      // eslint-disable-next-line no-alert,no-restricted-globals
      if (!confirm('今回の発送日を新しく追加します。よろしいですか？')) {
        return false;
      }
    }
    if (act === 'upd') {
      // 上書き更新
      // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
      // eslint-disable-next-line no-alert,no-restricted-globals
      if (!confirm('既存の発送日を今回の発送日で上書きします。よろしいですか？')) {
        return false;
      }
    }
    if (act === '') {
      // キャンセル
      // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
      // eslint-disable-next-line no-alert,no-restricted-globals
      if (!confirm('画面をクリアして初期画面を表示します。よろしいですか？')) {
        return false;
      }
    }
    if (act === 'clear') {
      // 発送日クリア
      // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
      // eslint-disable-next-line no-alert,no-restricted-globals
      if (!confirm('成績書発送日をクリアします。よろしいですか？')) {
        return false;
      }
    }
    const { onSubmit, formValues, setkey, rsvno } = this.props;
    onSubmit({ key: rsvno, cslDate: formValues.cslDate, act });
    setkey();
    return false;
  }
  // 描画処理
  render() {
    const { handleSubmit, strAction, formValues, blnCslInfoFlg, payload1, payload3, message, rsvno, setkey } = this.props;
    const strMessage = (Action) => {
      switch (Action) {
        case '':
          return <font size="6"><font color="#ff6600"> 成績書のバーコード</font > を読み込んでください。</font>;
        case 'saveend':
          return <font size="6">成績書発送確認が完了しました。</font>;
        case 'saveerr':
          return <font size="6">受診者が見つかりません。</font>;
        case 'clearend':
          return <font size="6">成績書発送日をクリアしました。</font>;
        case 'clearerr':
          return <font size="6">成績書発送日をクリアに失敗しました。</font>;
        case 'checkerr':
          setkey();
          return message.map((item, index) => (
            <RedHtml key={index.toString()}>{item}</RedHtml>
          ));
        case 'choisemode':
          return <font size="6"><font color="red">既に発送確認済みです。処理を選択してください。</font ></font>;
        default:
          return '';
      }
    };
    return (
      <div>
        <PageLayout title="成績書発送確認">
          <div style={{ width: 200, height: 200, float: 'left' }} />
          <div style={{ float: 'left', marginTop: '40px', marginLeft: '20px' }}>
            <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
              <FieldGroup itemWidth={80}>
                <FieldSet>
                  <Label>
                    {strMessage(strAction)}
                  </Label>
                </FieldSet>
                {strAction === 'choisemode' ?
                  <div>
                    {payload1.map((item) => (
                      <Table striped hover key={item.seq}>
                        <thead>
                          <tr>
                            <th>最新登録番号</th>
                            <th>{item.seq}</th>
                            <th>発送確認日時</th>
                            <th>{moment(item.reportsenddate).format('YYYY/MM/DD h:mm:ss')}</th>
                            <th>発送確認担当者</th>
                            <th>{item.chargeusername}</th>
                          </tr>
                        </thead>
                        <tbody style={{ color: 'gray' }}>
                          <tr>
                            <td />
                            <td />
                            <td>登録日時</td>
                            <td>{moment(item.insdate).format('YYYY/MM/DD h:mm:ss')}</td>
                            <td>登録担当者</td>
                            <td>{item.insusername}</td>
                          </tr>
                        </tbody>
                      </Table>
                    ))}
                    <FieldSet>
                      <Button value="新しく発送日を追加" onClick={() => this.handleClick('forceins')} />
                      <Button value="既存の発送日を更新" onClick={() => this.handleClick('upd')} />
                      <Button value="キャンセル" onClick={() => this.handleClick('')} />
                    </FieldSet>
                  </div>
                  :
                  <div>
                    <FieldSet>
                      <FieldItem>BarCode</FieldItem>
                      <Field name="key" component={TextBox} style={{ width: '130px' }} maxLength="18" onKeyDown={(event) => this.handleSubmit(event)} />
                    </FieldSet>
                    <FieldSet>
                      <FieldItem>発送日</FieldItem>
                      <Field name="cslDate" component={DatePicker} id="cslDate" />
                    </FieldSet>
                  </div>
                }
                {blnCslInfoFlg &&
                  <div>
                    <div style={{ height: '21px' }}>
                      {strAction === 'saveend' &&
                        <RedHtml>{moment(formValues.cslDate).format('YYYY/M/D')} {moment().format('hh:mm a')} 発送確認完了</RedHtml>
                      }
                    </div>
                    <div>
                      受診日：
                      <OraHtml>{moment(payload3.csldate).format('YYYY/MM/DD')}</OraHtml>
                      &nbsp;コース：
                      <OraHtml>{payload3.csname}</OraHtml>
                      &nbsp;当日ＩＤ：
                      <OraHtml>{payload3.dayid}</OraHtml>
                      &nbsp;団体：
                      <span>{payload3.orgname}</span>
                    </div>
                    <div>
                      <span>{payload3.perid}</span>&nbsp;
                      <span><b>{payload3.lastname} {payload3.firstname}</b>({payload3.lastkname} {payload3.firstkname})</span>&nbsp;
                      <span>
                        {payload3.birthyearshorteraname}
                        {payload3.birtherayear}
                        {moment(payload3.birth).format('(YYYY).M.D')}
                        生&nbsp;
                        {parseInt(moment(payload3.birth).fromNow(), 10) - 1}
                        歳
                        ({parseInt(payload3.age, 10)}歳)&nbsp;
                        {payload3.gender === 1 ? '男性' : '女性'}
                      </span>
                    </div>
                    <div style={{ marginTop: '20px' }}>
                      <NavLink to={`/contents/reserve/main/${rsvno}`}>予約情報を参照</NavLink>
                      &nbsp;&nbsp;&nbsp;
                      {strAction !== 'clearend' &&
                        <a href="#" onClick={() => this.handleClick('clear')}>この受診者の成績書発送日をクリアする</a>
                      }
                    </div>
                  </div>
                }
              </FieldGroup>
            </form>
          </div>
        </PageLayout>
      </div>
    );
  }
}

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    strAction: state.app.report.reportSendDate.sendReport.strAction,
    payload1: state.app.report.reportSendDate.sendReport.payload1,
    payload3: state.app.report.reportSendDate.sendReport.payload3,
    blnCslInfoFlg: state.app.report.reportSendDate.sendReport.blnCslInfoFlg,
    message: state.app.report.reportSendDate.sendReport.message,
    rsvno: state.app.report.reportSendDate.sendReport.rsvno,
    initialValues: {
      cslDate: state.app.report.reportSendDate.sendReport.conditions.cslDate,
      key: '',
    },
  };
};

// propTypesの定義
ReportSendCheck.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  strAction: PropTypes.string,
  rsvno: PropTypes.string.isRequired,
  blnCslInfoFlg: PropTypes.bool,
  formValues: PropTypes.shape(),
  payload1: PropTypes.arrayOf(PropTypes.shape()),
  payload3: PropTypes.shape().isRequired,
  setkey: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string),
  onClose: PropTypes.func.isRequired,
};

// defaultPropsの定義
ReportSendCheck.defaultProps = {
  strAction: '',
  blnCslInfoFlg: false,
  formValues: {},
  payload1: [],
  message: [],
};

const ReportSendCheckForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(ReportSendCheck);

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  // 次へボタン押下時の処理
  onSubmit: (params) => {
    dispatch(getWelComeInfoRequest({ ...params, rsvno: params.key }));
  },
  setkey: () => {
    dispatch(blur(formName, 'key', ''));
  },
  onClose: () => {
    dispatch(initialStateRequest());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(ReportSendCheckForm));
