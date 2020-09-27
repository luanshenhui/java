import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import Moment from 'moment';
import qs from 'qs';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import { reduxForm } from 'redux-form';
import { FieldGroup, FieldSet } from '../../components/Field';
import Label from '../../components/control/Label';
import Table from '../../components/Table';
import {
  openDmdPaymentGuide, openDmdBurdenModifyGuide,
} from '../../modules/bill/demandModule';
import DmdPayment from './DmdPayment';
import MoneyFormat from './MoneyFormat';

const Font = styled.span`
    color:#${(props) => props.color};
`;


class DmdBurdenListBody extends React.Component {
  // コンポーネントがマウントされた直後に1回だけ呼ばれる処理
  constructor(props) {
    super(props);
    // このサンプルではsetStateで状態管理をしているが、実際はReduxのStoreで管理しなければならない
    this.getSortURL = this.getSortURL.bind(this);
    this.handleClickOpenDmdBurdenModify = this.handleClickOpenDmdBurdenModify.bind(this);
  }

  getSortURL(strWkSortName) {
    const { conditions, history, match } = this.props;
    let strWkSortType;
    if (strWkSortName === conditions.sortName) {
      if (conditions.sortType === '1') {
        strWkSortType = '2';
      } else {
        strWkSortType = '1';
      }
    } else {
      strWkSortType = '1';
    }
    conditions.sortName = strWkSortName;
    conditions.sortType = strWkSortType;
    conditions.page = 1;
    conditions.startPos = 1;
    history.push({
      pathname: match.url,
      search: qs.stringify(conditions),
    });
  }

  handleClickOpenDmdBurdenModify(billNo) {
    const { onOpenDmdBurdenModifyGuide, location } = this.props;
    // 請求書基本情報（２次内訳）
    // qsを利用してquerystringをオブジェクト型に変換
    const params = qs.parse(location.search, { ignoreQueryPrefix: true });
    onOpenDmdBurdenModifyGuide(billNo, params);
  }
  render() {
    const { burdenlist, onOpenDmdPaymentGuide, conditions } = this.props;
    return (
      <div>
        <FieldGroup>
          <FieldSet>
            <Label><Font color="cc9999">●</Font>「<b>請求書番号</b>」をクリックすると、請求書内容の修正画面が表示されます。</Label>
          </FieldSet>
        </FieldGroup>
        <Table striped hover >
          <thead>
            <tr style={{ backgroundColor: '#eeeeee' }}>
              <th
                onClick={() => this.getSortURL('1')}
                style={{ backgroundColor: conditions.sortName === '1' ? '#CCCCFF' : '', textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}
              >
                締め日
              </th>
              <th>請求書No.</th>
              <th
                onClick={() => this.getSortURL('2')}
                style={{ backgroundColor: conditions.sortName === '2' ? '#CCCCFF' : '', textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}
              >
                団体名
              </th>
              <th
                onClick={() => this.getSortURL('3')}
                style={{ backgroundColor: conditions.sortName === '3' ? '#CCCCFF' : '', textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}
              >
                団体カナ名
              </th>
              <th style={{ textAlign: 'right' }}>小計</th>
              <th style={{ textAlign: 'right' }}>消費税</th>
              <th style={{ textAlign: 'right' }}>請求金額</th>
              <th style={{ textAlign: 'right' }}>未収額</th>
              <th
                onClick={() => this.getSortURL('4')}
                style={{ backgroundColor: conditions.sortName === '4' ? '#CCCCFF' : '', textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}
              >
                入金日
              </th>
              <th style={{ textAlign: 'right' }}>入金額</th>
              <th>処理担当</th>
              <th>処理</th>
              <th>請求書発送日</th>
              <th>請求書コメント</th>
            </tr>
          </thead>
          <tbody>
            {burdenlist && burdenlist.map((rec) => (
              <tr key={rec.billno} style={{ backgroundColor: rec.delflg === 1 ? '#FFDDFF' : '' }} >
                <td style={{ textAlign: 'right' }}>{Moment(rec.closedate).format('YYYY/MM/DD')}</td>
                <td style={{ textAlign: 'right' }}>
                  <Font
                    color="006699"
                    onClick={() => this.handleClickOpenDmdBurdenModify(rec.billno)}
                  >
                    {rec.billno}
                  </Font>
                </td>
                <td style={{ textAlign: 'right' }}>{rec.orgname}</td>
                <td style={{ textAlign: 'right' }}>{rec.orgkname}</td>
                {(rec.strdisppricetotal !== null) && (
                  <td style={{ textAlign: 'right' }}><MoneyFormat money={rec.strdisppricetotal} /></td>
                )}
                {rec.strdisppricetotal === null && (
                  <td>{}</td>
                )}
                {(rec.strdisptaxtotal !== null) && (
                  <td style={{ textAlign: 'right' }}><MoneyFormat money={rec.strdisptaxtotal} /></td>
                )}
                {rec.strdisptaxtotal === null && (
                  <td style={{ textAlign: 'right' }} />
                )}
                {(rec.strdispbilltotal !== null) && (
                  <td style={{ textAlign: 'right' }}><b><MoneyFormat money={rec.strdispbilltotal} /></b></td>
                )}
                {rec.strdispbilltotal === null && (
                  <td>{}</td>
                )}
                {rec.strdispnopaymentprice !== null && (
                  <td
                    style={{ color: (rec.strdispnopaymentprice === null || rec.strdispnopaymentprice === 0) ? 'black' : 'red', textAlign: 'right' }}
                  >
                    <b><MoneyFormat money={rec.strdispnopaymentprice} /></b>
                  </td>
                )}
                {rec.strdispnopaymentprice == null && (
                  <td>{}</td>
                )}
                {rec.paymentdate !== null && (
                  <td style={{ textAlign: 'right' }}>{Moment(rec.paymentdate).format('YYYY/MM/DD')}</td>
                )}
                {rec.paymentdate === null && (
                  <td>{}</td>
                )}
                {rec.paymentprice !== null && (
                  <td style={{ textAlign: 'right' }}><MoneyFormat money={rec.paymentprice} /></td>
                )}
                {rec.paymentprice === null && (
                  <td>{}</td>
                )}
                <td style={{ textAlign: 'right' }}>{rec.username}</td>
                <td style={{ textAlign: 'right' }}>
                  <FieldSet>
                    <Font
                      color="006699"
                      onClick={() => onOpenDmdPaymentGuide(rec.billno, rec.seq)}
                    >
                      入金
                    </Font>
                  </FieldSet>
                </td>
                <td style={{ textAlign: 'right' }}>{rec.dispatchdate}</td>
                <td >{rec.billcomment}</td>
              </tr>
            ))}
          </tbody>
        </Table>
        <DmdPayment />
      </div>
    );
  }
}
// propTypesの定義
DmdBurdenListBody.propTypes = {
  burdenlist: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onOpenDmdPaymentGuide: PropTypes.func.isRequired,
  onOpenDmdBurdenModifyGuide: PropTypes.func.isRequired,
  conditions: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  location: PropTypes.shape().isRequired,
};

const DmdBurdenListBodyForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'DmdBurdenListBody',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  // enableReinitialize: true,
})(DmdBurdenListBody);

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  conditions: state.app.bill.demand.dmdBurdenList.conditions,
  allCount: state.app.bill.demand.dmdBurdenList.allCount,
  burdenlist: state.app.bill.demand.dmdBurdenList.burdenlist,
  billNo: state.app.bill.demand.dmdBurdenList.billNo,
});
// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onOpenDmdPaymentGuide: (billno, seq) => {
    // 開くアクションを呼び出す
    const formname = 'DmdDetailItmList';
    const Cookie = '';
    dispatch(openDmdPaymentGuide({ billno, seq, formname, Cookie }));
  },
  onOpenDmdBurdenModifyGuide: (billNo, qsParams) => {
    // 開くアクションを呼び出す
    // 請求書Ｎｏがなければ以降何もしない
    if (billNo === undefined) {
      return;
    }
    const params = {};
    params.billNo = billNo;
    params.limit = 10;
    params.page = 1;
    params.lineNo = null;
    params.params = qsParams;
    dispatch(openDmdBurdenModifyGuide(params));
  },
});
export default withRouter(connect(mapStateToProps, mapDispatchToProps)(DmdBurdenListBodyForm));
