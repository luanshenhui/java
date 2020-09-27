import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import moment from 'moment';
import { connect } from 'react-redux';
import { withRouter, Link } from 'react-router-dom';
import { Field, reduxForm, getFormValues, blur } from 'redux-form';
import PageLayout from '../../layouts/PageLayout';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import TextArea from '../../components/control/TextArea';
import Table from '../../components/Table';
import DropDown from '../../components/control/dropdown/DropDown';
import GuideButton from '../../components/GuideButton';
import DatePicker from '../../components/control/datepicker/DatePicker';
import { openOtherIncomeInfoGuideRequest } from '../../modules/bill/billModule';
import OtherIncomeInfoGuideForm from './OtherIncomeInfoGuideForm';
import {
  initializePerBill, createPerBillRequest,
  getPerPaymentRequest, deletePerBillRequest, getPerBillPersonRequest
  , openPerBillIncomeGuide, perBillPageManagement,
} from '../../modules/bill/perBillModule';
import Chip from '../../components/Chip';
import MessageBanner from '../../components/MessageBanner';
import PersonGuide from '../common/PersonGuide';
import { openPersonGuide } from '../../modules/preference/personModule';
import PerBillIncomeGuide from '../bill/PerBillIncomeGuide';
import MoneyFormat from './MoneyFormat';

// カスタマイズfontラベル
const Font = styled.span`
    size: ${(props) => props.size};
    color: #${(props) => props.color};
`;
const formName = 'CreatePerBill';
class CreatePerBill extends React.Component {
  constructor(props) {
    super(props);
    // このサンプルではsetStateで状態管理をしているが、実際はReduxのStoreで管理しなければならない
    this.state = {};
    const { match, conditions } = this.props;
    this.mode = match.params.mode;
    conditions.dmdDate = match.params.dmddate;
    conditions.billSeq = match.params.billseq;
    conditions.branchNo = match.params.branchno;
    if (!/^\d+(\.\d+)?$/.test(conditions.branchNo)) {
      conditions.branchNo = '0';
      match.params.branchno = '0';
    }
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleRemoveClick = this.handleRemoveClick.bind(this);
    this.handleRepresentationClick = this.handleRepresentationClick.bind(this);
    this.handleIncomeClick = this.handleIncomeClick.bind(this);
    this.handelDeletePer = this.handelDeletePer.bind(this);
    this.handelDeleteBill = this.handelDeleteBill.bind(this);
    this.handelSelectPerGuide = this.handelSelectPerGuide.bind(this);
    this.handelSelectBillGuide = this.handelSelectBillGuide.bind(this);
    this.handSelectedPerson = this.handSelectedPerson.bind(this);
    this.handSelectedBill = this.handSelectedBill.bind(this);
  }
  componentDidMount() {
    const { onLoad, match, initializeCrePerBill, setValue } = this.props;
    // 画面を初期化
    initializeCrePerBill();
    if (!match.params.mode) {
      setValue('billcomment', '');
    } else {
      onLoad(match.params);
    }
  }
  componentWillReceiveProps(nextProps) {
    const { pageManagement, refresh, match, onLoad, closed } = this.props;
    if (nextProps.closed && nextProps.closed !== closed) {
      onLoad(match.params);
      pageManagement({ initial: 'initial', mode: match.params.mode, branchno: match.params.branchno });
    }
    if (nextProps.refresh === refresh) {
      pageManagement({ mode: match.params.mode, branchno: match.params.branchno });
    }
  }
  componentWillUnmount() {
    const { initializeCrePerBill, pageManagement, match } = this.props;
    // 画面を初期化
    initializeCrePerBill();
    pageManagement({ initial: 'initial', mode: match.params.mode });
  }
  // 保存処理
  handleSubmit(sort) {
    const { onSubmit, match, history, formValues, conditions } = this.props;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この請求書を作成します。よろしいですか？')) {
      return;
    }
    conditions.sort = sort;
    // 新しい規則が成功してから実行する
    const redirect = (data) => {
      history.push(`/contents/demand/perbill/createPerBill/${
        data.dmddate}/${data.billseq.toString().padStart(5, '0')}/${data.branchno}/update`);
    };
    if (match.params.mode !== 'update' && !formValues.newdmddate) {
      formValues.newdmddate = moment().format('YYYY/MM/DD');
    }
    // 保存終了時は更新モードでリダイレクト
    onSubmit(formValues, match.params, conditions.perCount, conditions.billCount, match.params.mode, redirect);
  }
  // 個人情報クリア
  handelDeletePer(index) {
    const { pageManagement, match } = this.props;
    pageManagement({ initial: 'deletePer', perIndex: index, mode: match.params.mode });
  }
  // 明細情報のクリア
  handelDeleteBill(index) {
    const { pageManagement, match } = this.props;
    pageManagement({ initial: 'deleteBill', billIndex: index, mode: match.params.mode });
  }
  // 削除処理
  handleRemoveClick() {
    const { deletePerBillNo, match, history, pageManagement } = this.props;
    // 請求書未作成？
    if (!match.params.dmddate || !match.params.billseq || !match.params.branchno) {
      // eslint-disable-next-line no-alert,no-restricted-globals
      alert('請求書は未作成の為、削除できません');
      return;
    }
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('このデータを削除しますか？')) {
      return;
    }
    // モードを指定してsubmit
    deletePerBillNo(match.params, () => {
      const { setValue } = this.props;
      setValue('billcomment', '');
      history.replace('/contents/demand/perbill/createPerBill');
      pageManagement({ initial: 'deletePerBill', mode: match.params.mode });
    });
  }
  // 指定可能個人、可能明細をの表示処理  表示行数の変更
  handleRepresentationClick(values) {
    const { pageManagement, match } = this.props;
    pageManagement({ initial: 'addLine', perValues: values, billValues: values, mode: match.params.mode });
  }
  // 入金情報/返金情報ウィンドウ表示
  handleIncomeClick() {
    const { onOpenPerBillncomeGuide, match, conditions } = this.props;
    let perId = null;
    for (let i = 0; i < conditions.perCount.length; i += 1) {
      if (conditions.perCount[i].perid) {
        perId = conditions.perCount[i].perid;
        break;
      }
    }
    onOpenPerBillncomeGuide({ ...match.params, perid: perId });
  }
  // 個人ナビゲーション選択
  handelSelectPerGuide(index) {
    const { onOpenPerGuide, pageManagement, match } = this.props;
    pageManagement({ initial: 'selectPerGuide', addPerLine: 'add', perIndex: index, mode: match.params.mode });
    const onSelected = (data) => {
      this.handSelectedPerson(data);
    };
    onOpenPerGuide(onSelected);
  }
  // 明細ナビゲーション選択
  handelSelectBillGuide(index, data) {
    const { onOpenBillGuide, pageManagement, match } = this.props;
    pageManagement({ initial: 'selectBillGuid', addBillLine: 'add', billIndex: index, mode: match.params.mode });
    onOpenBillGuide({ divcd: data.otherlinedivcd, mode: 'person', billcount: 0, ...data });
  }
  // 個人ナビゲーション選択完了
  handSelectedPerson(selectedItemPer) {
    const { pageManagement, match } = this.props;
    pageManagement({ initial: 'selectedItemPer', selectedItemPer, mode: match.params.mode });
  }
  // 明細ナビゲーション選択完了
  handSelectedBill(selectedItemBill) {
    const { pageManagement, match } = this.props;
    pageManagement({ initial: 'selectedItemBill', selectedItemBill, mode: match.params.mode });
  }

  // 描画処理
  render() {
    const { handleSubmit, dataNo, dataPay, message, formValues, conditions, err, match } = this.props;
    const { dmddate, billseq, branchno, mode } = match.params;
    return (
      <PageLayout title="個人請求書新規作成">
        <form >
          <div>
            <FieldGroup itemWidth={120}>
              {mode === 'update' ?
                <div>
                  <Font color={err === 'err' ? 'FF0000' : 'FF9900'} size="14"><MessageBanner messages={message} /></Font>
                  <FieldSet>
                    <FieldItem>請求書No</FieldItem>
                    <Label>{moment(dmddate).format('YYYYMMDD')}{billseq.toString().padStart(5, '0')}{!/^\d+(\.\d+)?$/.test(branchno) ? '0' : branchno}</Label>
                  </FieldSet>
                  <FieldSet>
                    <FieldItem>請求発生日</FieldItem>
                    <Label>{moment(dmddate).format('YYYY年MM月DD日')}</Label>
                  </FieldSet>
                </div>
                :
                <div>
                  <Font color={err === 'err' ? 'FF0000' : 'FF9900'} size="14"><MessageBanner messages={message} /></Font>
                  <FieldSet>
                    <FieldItem>請求発生日</FieldItem>
                    <Field name="newdmddate" component={DatePicker} />
                  </FieldSet>
                </div>
              }
              {mode === 'update' && conditions.lngPaymentFlg !== 0 ?
                <div>
                  <FieldSet>
                    <FieldItem>請求書コメント</FieldItem>
                    <Field name="billcomment" component={TextArea} id="billcomment" style={{ width: 500, height: 100 }} disabled />
                  </FieldSet>
                </div>
                :
                <div>
                  <FieldSet>
                    <FieldItem>請求書コメント</FieldItem>
                    <Field name="billcomment" component={TextArea} id="billcomment" style={{ width: 500, height: 100 }} />
                  </FieldSet>
                  <FieldSet>
                    <Button onClick={handleSubmit(() => this.handleSubmit('sort'))} value="保 存" />
                  </FieldSet>
                </div>
              }
            </FieldGroup>
            <br />
            <Table striped hover style={{ width: 600 }}>
              <thead>
                <tr bgcolor="#eeeeee">
                  <th>{}</th>
                  <th>{}</th>
                  <th style={{ width: 5 }}>{}</th>
                  <th>個人ＩＤ</th>
                  <th style={{ width: 5 }}>{}</th>
                  <th>受診者名</th>
                </tr>
              </thead>
              <tbody>
                {conditions.perCount.map((rec, index) => (
                  <tr key={rec.constructor === Object ? index : index}>
                    {(mode !== 'update' || conditions.lngPaymentFlg === 0) ?
                      <td><GuideButton onClick={() => {
                        this.handelSelectPerGuide(index);
                      }}
                      />
                      </td>
                      :
                      <td>{}</td>
                    }
                    {(mode !== 'update' || conditions.lngPaymentFlg === 0) ?
                      <td>
                        {rec.constructor === Object && (
                          <Chip onDelete={() => this.handelDeletePer(index)} />
                        )}
                      </td>
                      :
                      <td>{}</td>
                    }
                    <td style={{ width: 5 }}>{}</td>
                    <td>{rec.perid}</td>
                    <td style={{ width: 5 }}>{}</td>
                    <td>
                      <Font>{rec.perid !== null ?
                        <Font><b>{rec.lastname}{rec.firstname}</b><Font>{rec.perid ? '(' : ''}</Font>
                          <Font>{rec.lastkname}{rec.firstkname}</Font><Font>{rec.perid ? ')' : ''}</Font>
                        </Font>
                        :
                        <Font>{}</Font>
                      }
                      </Font>
                    </td>
                  </tr>))}
              </tbody>
            </Table>
            <FieldGroup>
              {(mode !== 'update' || conditions.lngPaymentFlg === 0) && (
                <FieldSet>
                  <Label>指定可能個人を</Label>
                  <Field name="perCount" component={DropDown} items={conditions.delflgItems1} id="perCount" />
                  <Label>{}</Label>
                  <Button value="表 示" onClick={() => this.handleRepresentationClick(formValues)} />
                </FieldSet>
              )}
            </FieldGroup>
            <br />
            <Table striped hover style={{ width: 600 }}>
              <thead>
                <tr bgcolor="#eeeeee">
                  <th>{}</th>
                  <th>{}</th>
                  <th>請求明細分類</th>
                  <th style={{ textAlign: 'right' }}>  金額</th>
                  <th style={{ textAlign: 'right' }}>調整金額</th>
                  <th style={{ textAlign: 'right' }}>　税額</th>
                  <th style={{ textAlign: 'right' }}>調整税額</th>
                  <th style={{ textAlign: 'right', width: 69 }}>合計金額</th>
                </tr>
              </thead>
              <tbody>
                {conditions.billCount.map((rec, index) => (
                  <tr key={rec.constructor === Object ? index : index}>
                    {(mode !== 'update' || conditions.lngPaymentFlg === 0) && (
                      <td><GuideButton onClick={() => {
                        this.handelSelectBillGuide(index, rec);
                      }}
                      />
                      </td>)}
                    {(mode !== 'update' || conditions.lngPaymentFlg === 0) && (
                      <td>
                        {rec.constructor === Object && (
                          <Chip onDelete={() => this.handelDeleteBill(index)} />
                        )}
                      </td>
                    )}
                    {(mode === 'update' && conditions.lngPaymentFlg !== 0) && (<td style={{ width: 20 }}>{}</td>)}
                    {(mode === 'update' && conditions.lngPaymentFlg !== 0) && (<td style={{ width: 20 }}>{}</td>)}
                    <td>{rec.linename ? rec.linename : rec.otherlinedivname}</td>
                    <td align="right">{rec.otherlinedivcd ? <MoneyFormat money={Number(rec.price)} /> : ''}</td>
                    <td align="right">{rec.otherlinedivcd ? <MoneyFormat money={Number(rec.editprice)} /> : ''}</td>
                    <td align="right">{rec.otherlinedivcd ? <MoneyFormat money={Number(rec.taxprice)} /> : ''}</td>
                    <td align="right">{rec.otherlinedivcd ? <MoneyFormat money={Number(rec.edittax)} /> : ''}</td>
                    <td align="right">
                      {rec.otherlinedivcd ? <MoneyFormat money={Number(rec.price) + Number(rec.editprice) + Number(rec.taxprice) + Number(rec.edittax)} /> : ''}
                    </td>
                  </tr>
                ))}
                <tr>
                  <td>{}</td>
                  <td>{}</td>
                  <td align="right">合計</td>
                  <td align="right"><MoneyFormat money={conditions.priceTotal} /></td>
                  <td align="right"><MoneyFormat money={conditions.editPriceTotal} /></td>
                  <td align="right"><MoneyFormat money={conditions.taxPriceTotal} /></td>
                  <td align="right"><MoneyFormat money={conditions.editTaxTotal} /></td>
                  <td align="right"><b><MoneyFormat money={conditions.total} /></b></td>
                </tr>
              </tbody>
            </Table>
            <FieldGroup>
              {(mode !== 'update' || conditions.lngPaymentFlg === 0) && (
                <FieldSet>
                  <Label>指定可能明細を</Label>
                  <Field name="billCount" component={DropDown} items={conditions.delflgItems2} id="billCount" />
                  <Label>{}</Label>
                  <Button value="表 示" onClick={() => this.handleRepresentationClick(formValues)} />
                </FieldSet>
              )}
            </FieldGroup>
            <br />
            <PerBillIncomeGuide />
            <FieldGroup>
              {!dmddate ?
                <FieldSet>
                  <Label><Font color="cc9999">●</Font></Label>
                  <Font>入金情報</Font>
                </FieldSet>
                :
                <FieldSet>
                  <Label><Font color="cc9999">●</Font></Label>
                  {branchno === '1' ?
                    <Link to="#"><Font color="006699" onClick={this.handleIncomeClick}>返金情報</Font></Link>
                    :
                    <Link to="#"><Font color="006699" onClick={this.handleIncomeClick}>入金情報</Font></Link>
                  }
                </FieldSet>
              }
            </FieldGroup>
            <Table striped hover style={{ width: 800 }}>
              <thead>
                <tr>
                  {branchno === '1' ? <th>返金日</th> : <th>入金日</th>}
                  <th>現金</th>
                  <th style={{ textAlign: 'right' }}>クレジット</th>
                  <th style={{ textAlign: 'right' }}>Jデビッド</th>
                  <th style={{ textAlign: 'right' }}>ハッピー買物</th>
                  <th style={{ textAlign: 'right' }}>小切手・フレンズ</th>
                  <th style={{ textAlign: 'right' }}>振込み</th>
                  <th>オペレータ</th>
                </tr>
              </thead>
              <tbody>
                {conditions.lngPaymentFlg === 0 ? <tr><td>{branchno === '1' ? <b>返金されていません。</b> : <b>入金されていません。</b>}</td></tr>
                  :
                  (dataPay.map((rec, index) => (
                    index === 0 && (
                      <tr key={`${rec.credit}-${rec.pricetotal}`}>
                        {dataNo.map((value, index1) => (
                          index1 === 0 &&
                          <td key={value.upduser}><Link to="#"><Font color="006699" onClick={this.handleIncomeClick}>{moment(value.paymentdate).format('YYYY/MM/DD')}</Font></Link></td>))
                        }
                        <td align="right"><b><MoneyFormat money={Number(rec.credit)} /></b></td>
                        <td align="right"><b><MoneyFormat money={Number(rec.card)} /></b></td>
                        <td align="right"><b><MoneyFormat money={Number(rec.jdebit)} /></b></td>
                        <td align="right"><b><MoneyFormat money={Number(rec.happy_ticket)} /></b></td>
                        <td align="right"><b><MoneyFormat money={Number(rec.cheque)} /></b></td>
                        <td align="right"><b><MoneyFormat money={Number(rec.transfer)} /></b></td>
                        <td>{rec.username}</td>
                      </tr>)
                  )))}
              </tbody>
            </Table>
            <br />
            {conditions.delflg !== 1 && (
              <FieldGroup>
                <FieldSet>
                  <Link to="#">
                    <Font
                      color="006699"
                      onClick={() => {
                        this.handleRemoveClick();
                      }}
                    >
                      この請求書を取り消す
                    </Font>
                  </Link>
                </FieldSet>
              </FieldGroup>
            )}
          </div>
        </form>
        <OtherIncomeInfoGuideForm
          onSelected={(selectedItemBill) => {
            this.handSelectedBill(selectedItemBill);
          }}
        />
        <PersonGuide />
      </PageLayout>
    );
  }
}

// propTypesの定義
CreatePerBill.propTypes = {
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  dataNo: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  dataPay: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  deletePerBillNo: PropTypes.func.isRequired,
  formValues: PropTypes.shape(),
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  initializeCrePerBill: PropTypes.func.isRequired,
  onOpenPerGuide: PropTypes.func.isRequired,
  onOpenBillGuide: PropTypes.func.isRequired,
  conditions: PropTypes.shape().isRequired,
  onOpenPerBillncomeGuide: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  pageManagement: PropTypes.func.isRequired,
  err: PropTypes.string.isRequired,
  refresh: PropTypes.string.isRequired,
  closed: PropTypes.string,
};
// defaultPropsの定義
CreatePerBill.defaultProps = {
  formValues: undefined,
  closed: undefined,
};
const CreatePerBillForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(CreatePerBill);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    initialValues: {
      billcomment: state.app.bill.perBill.perBillGuide.conditions.billcomment,
      newdmddate: moment().format('YYYY/MM/DD'),
      perCount: state.app.bill.perBill.mergePerBillGuide.perCnt,
      billCount: state.app.bill.perBill.mergePerBillGuide.billCnt,
    },
    formValues,
    dataNo: state.app.bill.perBill.perBillList.dataNo,
    dataPay: state.app.bill.perBill.perBillList.dataPay,
    dataPer: state.app.bill.perBill.perBillList.dataPer,
    dataC: state.app.bill.perBill.perBillList.dataC,
    conditions: state.app.bill.perBill.perBillGuide.conditions,
    err: state.app.bill.perBill.perBillInfo.error,
    message: state.app.bill.perBill.perBillInfo.message,
    refresh: state.app.bill.perBill.perBillGuide.refresh,
    closed: state.app.bill.perBill.perBillIncome.closed,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  initializeCrePerBill: () => {
    // 画面を初期化
    dispatch(initializePerBill());
  },
  onLoad: (params) => {
    // 請求書Ｎｏから個人IDを取得しそれぞれの個人情報を取得するの対処する
    // 個人請求明細情報の取得の対処する
    // 個人請求管理情報の取得の対処する
    dispatch(getPerBillPersonRequest({ params }));
  },
  // 入金情報の取得の対処する
  getPerBillPayment: (paymentdate, paymentseq) => {
    dispatch(getPerPaymentRequest({ paymentdate, paymentseq }));
  },
  // この請求書を取消の対処する
  deletePerBillNo: (params, redirect) => {
    dispatch(deletePerBillRequest({ params, redirect }));
  },
  onSubmit: (formValues, params, perCountData, billCountData, mode, redirect1) => {
    dispatch(createPerBillRequest({ formValues, params, perCountData, billCountData, mode, redirect1 }));
  },
  // 受診者ボタン開く
  onOpenPerGuide: (onSelected) => {
    dispatch(openPersonGuide({ onSelected }));
  },
  // セット外請求明細登録・修正ボタン開く
  onOpenBillGuide: (data) => {
    dispatch(openOtherIncomeInfoGuideRequest(data));
  },

  onOpenPerBillncomeGuide: (params) => {
    dispatch(openPerBillIncomeGuide(params));
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
  // ページ管理
  pageManagement: (params) => {
    dispatch(perBillPageManagement(params));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(CreatePerBillForm));
