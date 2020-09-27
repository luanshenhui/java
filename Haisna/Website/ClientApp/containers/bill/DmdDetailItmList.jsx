import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm, blur } from 'redux-form';
import moment from 'moment';
import GuideButton from '../../components/GuideButton';
import GuideBase from '../../components/common/GuideBase';

import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Button from '../../components/control/Button';
import Label from '../../components/control/Label';
import Table from '../../components/Table';
import DropDown from '../../components/control/dropdown/DropDown';
import DmdEditDetailItemLine from './DmdEditDetailItemLine';
import {
  closeDmdDetailItmListGuide, openDmdEditDetailItemLine, getDmdEditDetailItemLineRequest, openDmdDetailItmListGuide,
} from '../../modules/bill/demandModule';
import MoneyFormat from './MoneyFormat';

const formName = 'dmdDetailItmList';
const Font = styled.span`
    color:#${(props) => props.color};
`;
const Wrapper = styled.div`
  height: 750px;
  margin-top: 10px;
  overflow-y: auto;
`;
const delflgItems = [
  { value: 10, name: '10件ずつ' },
  { value: 20, name: '20件ずつ' },
  { value: 50, name: '50件ずつ' },
  { value: 0, name: '全データ' },
];
class DmdDetailItmList extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
  }
  componentWillReceiveProps(nextProps) {
    const { detailList, onLoad, billNo, lineNo, conditions, lngCount, setValues, visibleLine } = this.props;
    if (nextProps.detail.length !== 0 && nextProps.detailList !== detailList && !nextProps.visibleLine && visibleLine) {
      conditions.limit = 10;
      conditions.page = 1;
      conditions.billNo = billNo;
      conditions.lineNo = lineNo;
      onLoad(conditions, lngCount, billNo);
    }
    if (!nextProps.visible) {
      conditions.limit = 10;
      conditions.page = 1;
      setValues('limit', '10');
    }
  }
  // 送信
  handleSubmit(values) {
    const { onLoad, billNo, conditions, totalCount, lineNo, lngCount } = this.props;
    if (values.limit === '0') {
      conditions.limit = totalCount + 1;
    } else {
      conditions.limit = values.limit;
    }
    if (totalCount / Number(conditions.limit) < conditions.page) {
      conditions.page = 1;
    }
    conditions.billNo = billNo;
    conditions.lineNo = lineNo;
    onLoad(conditions, lngCount, billNo);
  }

  render() {
    const { Total, onLoad, handleSubmit, billNo, detail,
      onOpenDmdEditDetailItemLine, lineNo, totalCount, lngCount,
      count, detailList, conditions } = this.props;
    const onSelect = (page) => {
      const pageSearch = true;
      conditions.page = page;
      conditions.billNo = billNo;
      conditions.lineNo = lineNo;
      onLoad(conditions, lngCount, billNo, pageSearch);
    };

    return (
      <GuideBase {...this.props} title="請求書基本情報（２次内訳）" onSearch={onSelect} limit={Number(conditions.limit)} page={Number(conditions.page)} usePagination>
        <form>
          <Wrapper>
            <div>
              {count.map((rec) => (
                <span key={`${rec.payment_cnt}-${rec.dispatch_cnt}`}>
                  {rec.payment_cnt === 0 && rec.dispatch_cnt === 0 && <Button
                    onClick={() => {
                      onOpenDmdEditDetailItemLine(detail[0]);
                    }}
                    value="新 規"
                  />}
                </span>
              ))}
            </div>
            {lngCount.map((val, index) => (
              (index === 0 && (
                <div key={`${val.seq}-${val.billno}-${val.orgcd1}`}>
                  {detail.map((rec1) => (
                    <div key={`${rec1.rowseq}-${rec1.billno}`}>
                      <FieldGroup itemWidth={150}>
                        <FieldSet>
                          <FieldItem>請求書番号</FieldItem>
                          <Label>{rec1.billno}</Label>
                        </FieldSet>
                        <FieldSet>
                          <FieldItem>請求先団体</FieldItem>
                          <Label>{rec1.orgname}</Label>
                        </FieldSet>
                        <FieldSet>
                          <FieldItem>締め日</FieldItem>
                          <Label>{moment(rec1.closedate).format('YYYY/MM/DD')}</Label>
                        </FieldSet>
                        <FieldSet>
                          <FieldItem>請求書出力日</FieldItem>
                          <Label>{(val.prtdate !== null) && (moment(val.prtdate).format('YYYY/MM/DD'))}</Label>
                        </FieldSet>
                        <FieldSet>
                          <FieldItem>請求金額</FieldItem>
                          <Label><MoneyFormat money={Total.billTotal} /> (内 消費税<MoneyFormat money={Total.dispTaxTotal} />)</Label>
                        </FieldSet>
                        <FieldSet>
                          <FieldItem>請求書発送日</FieldItem>
                          <Label>{val.dispatchdate !== null && (!(val.delflg === 1 && val.branchno === 0)) && (
                            (lngCount.map((value) => (
                              <span key={value.seq}>
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
                        <FieldSet>
                          <FieldItem>個人ID</FieldItem>
                          <Label>{rec1.perid}</Label>
                        </FieldSet>
                        <FieldSet>
                          <FieldItem>氏名</FieldItem>
                          <Label>{rec1.lastname}  {rec1.firstname}</Label>
                        </FieldSet>
                      </FieldGroup>
                    </div>))}
                  <br />
                  <FieldGroup>
                    <FieldSet>
                      <Label><font color="ff6600"><b>{totalCount}</b></font>件の明細情報が含まれています。</Label>
                    </FieldSet>
                    <FieldSet>
                      <span style={{ marginLeft: 360 }} />
                      <Field name="limit" component={DropDown} items={delflgItems} id="" />
                      <Label>{}</Label>
                      <Button onClick={handleSubmit((values) => this.handleSubmit(values))} value="表 示" />
                    </FieldSet>
                  </FieldGroup>
                  <br />
                  {detailList.length !== 0 && (
                    <Table striped hover style={{ width: 'auto' }}>
                      <thead>
                        <tr bgcolor="#eeeeee">
                          <th>２次内訳</th>
                          <th style={{ textAlign: 'right' }}>小計</th>
                          <th style={{ textAlign: 'right' }}>合計</th>
                          <th>処理</th>
                        </tr>
                      </thead>
                      <tbody>
                        {detailList.map((rec, index1) => (
                          <tr key={rec ? index1 : index1}>
                            <td>{rec.secondlinedivname}</td>
                            <td align="right"><MoneyFormat money={Total.dispPriceTotals[index1]} /> </td>
                            <td align="right"><MoneyFormat money={Total.dispBillTotals[index1]} /></td>
                            <td>
                              <Font
                                color="006699"
                                onClick={() => onOpenDmdEditDetailItemLine(rec)}
                              >
                                修正
                              </Font>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </Table>
                  )}
                </div>
              ))))}
          </Wrapper>
        </form>
        <DmdEditDetailItemLine />
      </GuideBase>
    );
  }
}

// propTypesの定義
DmdDetailItmList.propTypes = {
  lngCount: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  dispPriceTotals: PropTypes.number.isRequired,
  dispBillTotals: PropTypes.number.isRequired,
  billTotal: PropTypes.number.isRequired,
  dispTaxTotal: PropTypes.number.isRequired,
  detail: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  record: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  detailList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  match: PropTypes.shape().isRequired,
  conditions: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  totalCount: PropTypes.number,
  count: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  history: PropTypes.shape(),
  handleSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func.isRequired,
  onOpenDmdEditDetailItemLine: PropTypes.func.isRequired,
  Total: PropTypes.shape(),
  billNo: PropTypes.string,
  lineNo: PropTypes.number,
  visible: PropTypes.bool.isRequired,
  visibleLine: PropTypes.bool.isRequired,
  setValues: PropTypes.func.isRequired,
};
// defaultPropsの定義
DmdDetailItmList.defaultProps = {
  history: undefined,
  totalCount: 0,
  Total: undefined,
  lineNo: undefined,
  billNo: undefined,
};
const DmdDetailItmListForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  // enableReinitialize: true,
})(DmdDetailItmList);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  lngCount: state.app.bill.demand.dmdBurdenModify.lngCount,
  dispPriceTotals: state.app.bill.demand.dmdDetailItm.dispPriceTotals,
  dispBillTotals: state.app.bill.demand.dmdDetailItm.dispBillTotals,
  billTotal: state.app.bill.demand.dmdDetailItm.billTotal,
  dispTaxTotal: state.app.bill.demand.dmdDetailItm.dispTaxTotal,
  billNo: state.app.bill.demand.dmdDetailItmListGuide.billNo,
  lineNo: state.app.bill.demand.dmdDetailItmListGuide.lineNo,
  conditions: state.app.bill.demand.dmdDetailItm.conditions,
  detail: state.app.bill.demand.dmdBurdenModify.detail,
  record: state.app.bill.demand.dmdBurdenModify.record,
  detailList: state.app.bill.demand.dmdDetailItm.detailList,
  totalCount: state.app.bill.demand.dmdDetailItm.totalCount,
  count: state.app.bill.demand.dmdBurdenModify.count,
  Total: state.app.bill.demand.dmdBurdenModify.Total,
  // 可視状態
  visible: state.app.bill.demand.dmdDetailItmListGuide.visible,
  visibleLine: state.app.bill.demand.dmdEditDetailItemLine.visible,
  initialValues: {
    limit: state.app.bill.demand.dmdDetailItm.conditions.limit,
  },
});
const mapDispatchToProps = (dispatch) => ({
  onLoad: (conditions, lngCount, billNo, pageSearch) => {
    const params = {};
    params.billNo = conditions.billNo;
    params.lineNo = conditions.lineNo;
    params.lngCount = lngCount;
    Object.assign(params, conditions);
    dispatch(openDmdDetailItmListGuide({ params, billNo, pageSearch }));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeDmdDetailItmListGuide());
  },
  onOpenDmdEditDetailItemLine: (params) => {
    const billNo = params.billno;
    const lineNo = params.lineno;
    const startPos = 1;
    const limit = 10;
    dispatch(getDmdEditDetailItemLineRequest({ billNo, lineNo, startPos, limit }));
    dispatch(openDmdEditDetailItemLine(params));
  },
  setValues: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});
export default withRouter(connect(mapStateToProps, mapDispatchToProps)(DmdDetailItmListForm));
