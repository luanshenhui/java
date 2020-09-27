import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import { Link, withRouter } from 'react-router-dom';
import { Field, reduxForm, blur } from 'redux-form';
import styled from 'styled-components';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Button from '../../components/control/Button';
import GuideBase from '../../components/common/GuideBase';
import Label from '../../components/control/Label';
import Table from '../../components/Table';
import DropDown from '../../components/control/dropdown/DropDown';
import MessageBanner from '../../components/MessageBanner';
import GuideButton from '../../components/GuideButton';
import DmdDetailItmList from './DmdDetailItmList';
import {
  deleteDmdRequest, openDmdCommentGuide, getDmdListRequest,
  openDmdDetailItmListGuide, closeDmdBurdenModifyGuide,
  openDmdEditBillLineRequest, getDmdBurdenListRequest,
} from '../../modules/bill/demandModule';
import MoneyFormat from './MoneyFormat';
import DmdBillComment from './DmdBillComment';
import DmdEditBillLine from './DmdEditBillLine';

const formName = 'dmdBurdenModify';
const Font = styled.span`
  color: #${(props) => props.color};
  font-size: ${(props) => props.size};
`;
const Wrapper = styled.div`
  height: 750px;
  margin-top: 10px;
  overflow-y: auto;
`;
const Wrapper1 = styled.div`
  height: 300px;
  margin-top: 10px;
  overflow-y: auto;
`;
const delflgItems = [
  { value: 10, name: '10件ずつ' },
  { value: 20, name: '20件ずつ' },
  { value: 50, name: '50件ずつ' },
  { value: '*', name: '全データ' },
];
class DmdBurdenModify extends React.Component {
  constructor(props) {
    super(props);

    this.handleRemoveClick = this.handleRemoveClick.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleDetailItmClick = this.handleDetailItmClick.bind(this);
    this.handOnSelectedPage = this.handOnSelectedPage.bind(this);
  }
  componentWillReceiveProps(nextProps) {
    const { editVisible } = this.props;
    const { conditions, setValues } = this.props;
    if (nextProps.visible === false) {
      conditions.page = 1;
      conditions.limit = 10;
      setValues('limit', '10');
    }

    if (editVisible && nextProps.editVisible !== editVisible) {
      const { billNo, onLoad } = this.props;
      const params = { limit: '10', page: 1, billNo };
      onLoad(params);
    }
  }
  // 請求書基本情報呼び出し(請求書基本情報（２次内訳）)
  handleDetailItmClick(params) {
    const { onOpenDmdDetailItmListGuide, lngCount, billNo } = this.props;
    onOpenDmdDetailItmListGuide(params, lngCount, billNo);
  }
  // 削除
  handleRemoveClick() {
    const { onDelete, billNo, params } = this.props;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この請求書を削除します。よろしいですか？')) {
      return;
    }
    onDelete(billNo, 'delete', params);
  }
  // 戻るボタンクリック時の処理
  handleCancelClick() {
    const { onClose } = this.props;
    onClose();
  }
  handleSubmit(values) {
    const { billNo, onLoad, conditions, totalCount, lngCount } = this.props;
    if (values.limit === '*') {
      conditions.limit = totalCount + 1;
    } else {
      conditions.limit = values.limit;
    }
    if (totalCount / Number(conditions.limit) < conditions.page) {
      conditions.page = 1;
    }
    conditions.billNo = billNo;
    onLoad({ lngCount, ...conditions });
  }
  handOnSelectedPage(page) {
    const { billNo, onLoad, conditions } = this.props;
    conditions.page = page;
    conditions.billNo = billNo;
    onLoad(conditions);
  }
  render() {
    const { billComment, totalCount, message, onOpenDmdCommentGuide,
      data, count, conditions, handleSubmit, onOpenDmdEditBillLine,
      billTotal, dispTaxTotal, lngCount, act } = this.props;

    return (
      <GuideBase {...this.props} title="請求書基本情報" onSearch={this.handOnSelectedPage} limit={Number(conditions.limit)} page={Number(conditions.page)} usePagination>
        {act === 'delete' ?
          <div>
            <Wrapper1>
              <Button onClick={this.handleCancelClick} value="戻る " />
              <Font color="FF6600">
                <MessageBanner messages={message} />
              </Font>
            </Wrapper1>
          </div> :
          <div>
            <Wrapper>
              <DmdBillComment />
              <DmdEditBillLine />
              <form>
                <div>
                  {count.map((rec) => (
                    <span key={`${rec.payment_cnt}-${rec.dispatch_cnt}`}>
                      {rec.payment_cnt === 0 && rec.dispatch_cnt === 0 && (
                        <Button onClick={() => onOpenDmdEditBillLine({ BillNo: lngCount[0].billno, LineNo: null })} value="新 規" />
                      )}
                    </span>
                  ))}
                  {totalCount !== 0 && <Button value="印 刷" />}
                  {lngCount[0].delflg === 0 && <Button onClick={this.handleRemoveClick} value="削 除" />}
                </div>
                <div>
                  {lngCount.map((rec, index) => (
                    <div key={`${rec.orgcd1}-${rec.billno}-${rec.dispatchdate}`}>
                      {index <= 0 && (
                        <FieldGroup itemWidth={150}>
                          <FieldSet>
                            <FieldItem>請求書番号</FieldItem>
                            <Label>{rec.billno}</Label>
                          </FieldSet>
                          <FieldSet>
                            <FieldItem>請求書団体</FieldItem>
                            <Label>{rec.orgname}</Label>
                          </FieldSet>
                          <FieldSet>
                            <FieldItem>締め日</FieldItem>
                            <Label>{moment(rec.closedate).format('YYYY/MM/DD')}</Label>
                          </FieldSet>
                          <FieldSet>
                            <FieldItem>請求書出力日</FieldItem>
                            <Label>{(rec.prtdate !== null) && (moment(rec.prtdate).format('YYYY/MM/DD'))}</Label>
                          </FieldSet>
                          <FieldSet>
                            <FieldItem>請求金額</FieldItem>
                            <Label><MoneyFormat money={billTotal} /> (内 消費税<MoneyFormat money={dispTaxTotal} />)</Label>
                          </FieldSet>
                          <FieldSet>
                            <FieldItem>請求書コメント</FieldItem>
                            <FieldSet>
                              <GuideButton
                                onClick={() => {
                                  onOpenDmdCommentGuide(rec.billno);
                                }}
                              />
                              <Label>{billComment}</Label>
                            </FieldSet>
                          </FieldSet>
                          <FieldSet>
                            <FieldItem>請求書発送日</FieldItem>
                            <Label>
                              {rec.dispatchdate !== null && (!(rec.delflg === 1 && rec.branchno === 0)) && (
                                (lngCount.map((value) => (
                                  <span key={value.delflg}>
                                    <FieldSet>
                                      <GuideButton />
                                      <span>{value.dispatchdate}</span>
                                      <span style={{ marginLeft: 100 }}>更新者:</span>
                                      <span>{value.username}</span>
                                      <span style={{ marginLeft: 100 }}>更新日:</span>
                                      <span>{value.upddate}</span>
                                    </FieldSet>
                                  </span>))))}
                            </Label>
                          </FieldSet>
                        </FieldGroup>
                      )}
                    </div>))}
                  <br />
                  <FieldGroup>
                    <FieldSet>
                      <Label><Font color="ff6600"><b>{totalCount}</b></Font>件の明細情報が含まれています。</Label>
                    </FieldSet>
                    <FieldSet>
                      <span style={{ marginLeft: 360 }} />
                      <Field name="limit" component={DropDown} items={delflgItems} id="" />
                      <Label>{}
                      </Label>
                      <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="表 示" />
                    </FieldSet>
                  </FieldGroup>
                  <br />
                  {data.length !== 0 && (
                    <Table striped hover style={{ width: 'auto' }} >
                      <thead>
                        <tr bgcolor="#eeeeee">
                          <th>受診日</th>
                          <th>当日ＩＤ</th>
                          <th>予約番号</th>
                          <th>個人ＩＤ</th>
                          <th>氏名</th>
                          <th>受診コース</th>
                          <th style={{ textAlign: 'right' }}>小計</th>
                          <th style={{ textAlign: 'right' }}>合計</th>
                          <th>処理</th>
                          <th>２次内訳</th>
                        </tr>
                      </thead>
                      <tbody>
                        {data.map((rec) => (
                          <tr key={`${rec.rowseq}-${rec.perid}`}>
                            <td >{rec.csldate && moment(rec.csldate).format('YYYY/MM/DD')}</td>
                            <td align="right">{rec.dayid}</td>
                            <td align="right"><Link to={`/contents/demand/perbill/perPaymentInfo/${rec.rsvno}`}><Font color="006699">{rec.rsvno}</Font></Link></td>
                            <td >{rec.perid}</td>
                            <td><Font size="9px"><b>{rec.lastkname}  {rec.firstkname}</b><br /></Font>{rec.lastname}  {rec.firstname}</td>
                            <td >{rec.detailname}</td>
                            <td align="right"><MoneyFormat money={rec.dispPriceTotal} /> </td>
                            <td align="right"><MoneyFormat money={rec.dispBillTotal} /></td>
                            <td ><Font color="006699" onClick={() => onOpenDmdEditBillLine({ BillNo: rec.billno, LineNo: rec.lineno })}>修正</Font></td>
                            <td >
                              {rec.secondflg === 1 && (
                                <Font color="006699" onClick={() => this.handleDetailItmClick(rec)}>
                                  ２次内訳
                                </Font>
                              )}
                              {rec.secondflg !== 1 && ''}
                            </td>
                          </tr>
                        ))
                        }
                      </tbody>
                    </Table>
                  )}
                  <br />
                </div>
              </form>
            </Wrapper>
            <DmdDetailItmList />
          </div>
        }

      </GuideBase >
    );
  }
}

// propTypesの定義
DmdBurdenModify.propTypes = {
  lngCount: PropTypes.arrayOf(PropTypes.shape()),
  dispTaxTotal: PropTypes.number.isRequired,
  billTotal: PropTypes.number.isRequired,
  editVisible: PropTypes.bool.isRequired,
  onOpenDmdEditBillLine: PropTypes.func.isRequired,
  onOpenDmdDetailItmListGuide: PropTypes.func.isRequired,
  onOpenDmdCommentGuide: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
  match: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  history: PropTypes.shape(),
  billNo: PropTypes.string.isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  count: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  record: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  conditions: PropTypes.shape().isRequired,
  totalCount: PropTypes.number,
  billComment: PropTypes.string,
  handleSubmit: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onClose: PropTypes.func.isRequired,
  act: PropTypes.string.isRequired,
  params: PropTypes.shape(),
  delflg: PropTypes.number,
  setValues: PropTypes.func.isRequired,
  visible: PropTypes.bool.isRequired,
};
// defaultPropsの定義
DmdBurdenModify.defaultProps = {
  lngCount: undefined,
  history: undefined,
  totalCount: 0,
  billComment: '',
  params: undefined,
  delflg: 0,
};
const DmdBurdenModifyForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  // enableReinitialize: true,
})(DmdBurdenModify);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  lngCount: state.app.bill.demand.dmdBurdenModify.lngCount,
  dispTaxTotal: state.app.bill.demand.dmdBurdenModify.dispTaxTotal,
  billTotal: state.app.bill.demand.dmdBurdenModify.billTotal,
  editVisible: state.app.bill.demand.dmdEditBillLine.visible,
  billNo: state.app.bill.demand.dmdBurdenModify.billNo,
  data: state.app.bill.demand.dmdBurdenModify.data,
  count: state.app.bill.demand.dmdBurdenModify.count,
  conditions: state.app.bill.demand.dmdBurdenModify.conditions,
  record: state.app.bill.demand.dmdBurdenModify.record,
  totalCount: state.app.bill.demand.dmdBurdenModify.totalCount,
  billComment: state.app.bill.demand.dmdBurdenModify.billComment,
  act: state.app.bill.demand.dmdBurdenModify.act,
  // 可視状態
  visible: state.app.bill.demand.dmdBurdenModify.visible,
  selectedItem: state.app.bill.demand.dmdBurdenModifyGuide.selectedItem,
  message: state.app.bill.demand.dmdBurdenModify.message,
  params: state.app.bill.demand.dmdBurdenModify.params,
  initialValues: {
    limit: state.app.bill.demand.dmdBurdenModify.conditions.limit,
  },
});

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    const { billNo } = params;
    // 請求書Ｎｏがなければ以降何もしない
    if (billNo === undefined) {
      return;
    }
    dispatch(getDmdListRequest({ params }));
  },
  onOpenDmdEditBillLine: (params) => {
    // 開くアクションを呼び出す
    dispatch(openDmdEditBillLineRequest(params));
  },
  onOpenDmdCommentGuide: (params) => {
    // 請求書コメン
    dispatch(openDmdCommentGuide({ params }));
  },
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeDmdBurdenModifyGuide());
  },
  onOpenDmdDetailItmListGuide: (param, lngCount, billNo) => {
    const params = {};
    params.billNo = param.billno;
    params.lineNo = param.lineno;
    params.lngCount = lngCount;
    const { billno } = param;
    // 請求書Ｎｏがなければ以降何もしない
    if (billno === undefined) {
      return;
    }
    Object.assign(params, param);
    params.limit = 10;
    params.page = 1;
    dispatch(openDmdDetailItmListGuide({ params, billNo }));
  },
  onDelete: (params, act, conditions) => {
    dispatch(deleteDmdRequest({ params, act }));
    const page = 1;
    const startPos = 1;
    dispatch(getDmdBurdenListRequest({ page, startPos, ...conditions }));
  },
  setValues: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});
export default withRouter(connect(mapStateToProps, mapDispatchToProps)(DmdBurdenModifyForm));
