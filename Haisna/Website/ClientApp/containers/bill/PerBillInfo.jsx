import React from 'react';
import PropTypes from 'prop-types';
import qs from 'qs';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { Link } from 'react-router-dom';
import moment from 'moment';
import PageLayout from '../../layouts/PageLayout';
import MessageBanner from '../../components/MessageBanner';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import Button from '../../components/control/Button';
import Table from '../../components/Table';
import GuideButton from '../../components/GuideButton';
import PerBillComment from '../bill/PerBillComment';
import PerBillIncomeGuide from '../bill/PerBillIncomeGuide';
import {
  getPerBillInfoRequest, deletePerBillInfoRequest, openMergeGuideRequest,
  openPerBillGuide, initializeBillComment, openPerBillIncomeGuide,
  getPerBillNoRequest,
} from '../../modules/bill/perBillModule';
import MergePerBill from './MergePerBill';
import MoneyFormat from './MoneyFormat';

const IncomeSectionBar = styled.div`
  background-color: #b8b4ac;
  color: #fff;
  font-size: 17px;
  line-height: 1;
  margin: 10px 0;
  padding: 6px 9px;
`;
// カスタマイズfontラベル
const Font = styled.span`
    size: ${(props) => props.size};
    color: #${(props) => props.color};
`;

const formName = 'PerBillInfo';
class PerBillInfo extends React.Component {
  constructor(props) {
    super(props);

    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.handleDeleteClick = this.handleDeleteClick.bind(this);
    this.handleIncomeClick = this.handleIncomeClick.bind(this);
    this.handlePrintClick = this.handlePrintClick.bind(this);
    this.handleMergeClick = this.handleMergeClick.bind(this);
    this.handleCommentClick = this.handleCommentClick.bind(this);
  }

  componentDidMount() {
    const { onLoad, match } = this.props;
    onLoad(match.params);
  }

  // 戻るボタンクリック時の処理
  handleCancelClick() {
    const { history, urlValues } = this.props;
    history.push({
      pathname: '/contents/demand/perbill/perBillSearch',
      search: qs.stringify(urlValues),
    });
  }

  // 削除
  handleDeleteClick() {
    const { onDelete, match, history } = this.props;
    const { params } = match;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この請求書を削除します。よろしいですか？')) {
      return;
    }
    onDelete(match.params, () => history.replace(`/contents/reserve/perpaymentlist/${params.rsvno}`));
  }

  // 印刷ボタンを押下
  handlePrintClick() {
  }

  // 入金情報/返金情報ウィンドウ表示
  handleIncomeClick() {
    const { onOpenPerBillncomeGuide, match } = this.props;
    onOpenPerBillncomeGuide(match.params);
  }

  // 請求書コメントガイドを開く
  handleCommentClick() {
    const { onOpenPerBillGuide, initializePerBillComment } = this.props;
    initializePerBillComment();
    onOpenPerBillGuide();
  }

  // 他請求書と統合ボタンを押下
  handleMergeClick() {
    const { onOpenMergeGuideRequest, match } = this.props;
    // 請求書統合ウィンドウ表示
    onOpenMergeGuideRequest(match.params);
  }
  render() {
    const { match, message, perBillCsl, perBillC, perBillBillNo, perPayment, conditions } = this.props;

    const { dmddate, billseq, branchno } = match.params;

    let total = 0;
    let billName = '';
    if (perBillBillNo[0] && perBillCsl[0]) {
      total = perBillBillNo[0].price_all + perBillBillNo[0].editprice_all + perBillBillNo[0].taxprice_all + perBillBillNo[0].edittax_all;

      // 請求宛先
      billName = perBillBillNo[0].billname == null ? `${perBillCsl[0].lastname} ${perBillCsl[0].firstname}` : perBillBillNo[0].billname;

      // 請求宛先敬称
      if (perBillBillNo[0].keishou) {
        billName = ` ${perBillBillNo[0].keishou}`;
      } else {
        billName += ' 様';
      }
    }

    return (
      <PageLayout title="請求書情報">
        <MessageBanner messages={message} />

        <Button onClick={this.handleMergeClick} value="他請求書と統合" />
        <MergePerBill />
        <Button onClick={this.handlePrintClick} value="印刷" />
        <Button onClick={this.handleCancelClick} value="戻る" />

        <FieldGroup itemWidth={150}>
          <FieldSet>
            <FieldItem>請求発生日</FieldItem>
            <Label>{perBillCsl[0] && moment(dmddate).format('YYYY/MM/DD')}</Label>
          </FieldSet>
          <FieldSet>
            <FieldItem>請求書No</FieldItem>
            <Label>{perBillCsl[0] && moment(dmddate).format('YYYYMMDD') + `0000${billseq}`.slice(-5) + branchno}</Label>
          </FieldSet>
          <FieldSet>
            <FieldItem>請求金額</FieldItem>
            <Label>
              <strong>
                <MoneyFormat money={perBillBillNo[0] && total} />
              </strong>
              {perBillBillNo[0] && '（内　消費税'}<MoneyFormat money={perBillBillNo[0] && perBillBillNo[0].taxprice_all} />{perBillBillNo[0] && ')'}
            </Label>
          </FieldSet>
          <FieldSet>
            <FieldItem>請求書コメント</FieldItem>
            <Label><GuideButton onClick={this.handleCommentClick} /></Label>
            <FieldSet>{conditions.billcomment}</FieldSet>
            <PerBillComment {...this.props.match} />
          </FieldSet>
          <FieldSet>
            <FieldItem>宛名</FieldItem>
            <Label>{perBillBillNo[0] && billName}</Label>
          </FieldSet>
        </FieldGroup>

        {perBillBillNo[0] && ((perBillBillNo[0].printdate !== null && perBillBillNo[0].printdate !== '') || (perBillBillNo[0].paymentdate !== null && perBillBillNo[0].paymentdate !== '')) &&
          <span style={{ color: 'red' }}>※領収書印刷済もしくは入金済みの場合、請求書の統合はできません。</span>
        }

        <Table style={{ marginTop: '30px' }}>
          <thead>
            <tr>
              <th>受診日</th>
              <th>受診コース</th>
              <th>予約番号</th>
              <th>個人ＩＤ</th>
              <th>受診者名</th>
            </tr>
          </thead>
          <tbody>
            {perBillCsl && perBillCsl.map((rec) => (
              <tr key={rec.rsvno}>
                <td>{moment(rec.csldate).format('YYYY/MM/DD')}</td>
                <td>{rec.csname}</td>
                <td><Link to={`/contents/bill/${rec.rsvno}`}><Font color="006699">{rec.rsvno}</Font></Link></td>
                <td>{rec.perid}</td>
                <td><strong>{rec.lastname} {rec.firstname}</strong>{rec.lastkname && ` (${rec.lastkname}  ${rec.firstkname})`}</td>
              </tr>
            ))}
          </tbody>
        </Table>

        <Table style={{ marginTop: '40px' }}>
          <thead>
            <tr>
              <th>受診者</th>
              <th>請求明細名</th>
              <th style={{ textAlign: 'right' }}>　金額</th>
              <th style={{ textAlign: 'right' }}>調整金額</th>
              <th style={{ textAlign: 'right' }}>　税額</th>
              <th style={{ textAlign: 'right' }}>調整税額</th>
              <th style={{ textAlign: 'right' }}>合計金額</th>
            </tr>
          </thead>
          <tbody>
            {perBillC && perBillC.map((rec) => (
              <tr key={rec.billlineno}>
                <td>{rec.lastname} {rec.firstname}</td>
                <td>{rec.linename == null ? rec.otherlinedivname : rec.linename}</td>
                <td style={{ textAlign: 'right' }}><MoneyFormat money={rec.price} /></td>
                <td style={{ textAlign: 'right' }}><MoneyFormat money={rec.editprice} /></td>
                <td style={{ textAlign: 'right' }}><MoneyFormat money={rec.taxprice} /></td>
                <td style={{ textAlign: 'right' }}><MoneyFormat money={rec.edittax} /></td>
                <td style={{ textAlign: 'right' }}><MoneyFormat money={rec.price + rec.editprice + rec.taxprice + rec.edittax} /></td>
              </tr>
            ))}
            <tr>
              <td />
              <td style={{ textAlign: 'right' }}>合計</td>
              <td style={{ textAlign: 'right' }}><MoneyFormat money={perBillBillNo[0] && perBillBillNo[0].price_all} /></td>
              <td style={{ textAlign: 'right' }}><MoneyFormat money={perBillBillNo[0] && perBillBillNo[0].editprice_all} /></td>
              <td style={{ textAlign: 'right' }}><MoneyFormat money={perBillBillNo[0] && perBillBillNo[0].taxprice_all} /></td>
              <td style={{ textAlign: 'right' }}><MoneyFormat money={perBillBillNo[0] && perBillBillNo[0].edittax_all} /></td>
              <td style={{ textAlign: 'right' }}><strong><MoneyFormat money={perBillBillNo[0] && total} /></strong></td>
            </tr>
          </tbody>
        </Table>

        <div style={{ marginTop: '40px' }}>
          <PerBillIncomeGuide />
          <IncomeSectionBar>{<Font color="006699" onClick={this.handleIncomeClick}>{branchno === 1 ? '返金情報' : '入金情報'}</Font>}</IncomeSectionBar>
          <Table>
            <thead>
              <tr>
                <td>{branchno === 1 ? '返金日' : '入金日'}</td>
                <td style={{ textAlign: 'right' }}>現金</td>
                <td style={{ textAlign: 'right' }}>クレジット</td>
                <td style={{ textAlign: 'right' }}>Jデビッド</td>
                <td style={{ textAlign: 'right' }}>ハッピー買物</td>
                <td style={{ textAlign: 'right' }}>小切手・フレンズ</td>
                <td style={{ textAlign: 'right' }}>振込み</td>
                <td>オペレータ</td>
              </tr>
            </thead>
            <tbody>
              {
                perPayment.length === 0
                  ? <tr><td colSpan="8"><strong>{branchno === 1 ? '返金されていません。' : '入金されていません。'}</strong></td></tr>
                  :
                  <tr>
                    <td><Font color="006699" onClick={this.handleIncomeClick}>{perBillBillNo[0].paymentdate}</Font></td>
                    <td style={{ textAlign: 'right' }}><MoneyFormat money={perPayment[0].credit} /></td>
                    <td style={{ textAlign: 'right' }}><MoneyFormat money={perPayment[0].card} /></td>
                    <td style={{ textAlign: 'right' }}><MoneyFormat money={perPayment[0].jdebit} /></td>
                    <td style={{ textAlign: 'right' }}><MoneyFormat money={perPayment[0].happy_ticket} /></td>
                    <td style={{ textAlign: 'right' }}><MoneyFormat money={perPayment[0].cheque} /></td>
                    <td style={{ textAlign: 'right' }}><MoneyFormat money={perPayment[0].transfer} /></td>
                    <td>{perPayment[0].username}</td>
                  </tr>
              }
            </tbody>
          </Table>
        </div>

        <div style={{ marginTop: '30px' }}>
          {
            perBillBillNo[0] && perBillBillNo[0].delflg !== 1 && <Button onClick={this.handleDeleteClick} value="この請求書を取消" />
          }
        </div>
      </PageLayout>
    );
  }
}

PerBillInfo.propTypes = {
  match: PropTypes.shape().isRequired,
  history: PropTypes.shape().isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  perBillCsl: PropTypes.arrayOf(PropTypes.object).isRequired,
  perBillC: PropTypes.arrayOf(PropTypes.object).isRequired,
  perBillBillNo: PropTypes.arrayOf(PropTypes.object).isRequired,
  perPayment: PropTypes.arrayOf(PropTypes.object).isRequired,
  onLoad: PropTypes.func.isRequired,
  onDelete: PropTypes.func.isRequired,
  onOpenMergeGuideRequest: PropTypes.func.isRequired,
  initializePerBillComment: PropTypes.func.isRequired,
  onOpenPerBillGuide: PropTypes.func.isRequired,
  conditions: PropTypes.shape().isRequired,
  onOpenPerBillncomeGuide: PropTypes.func.isRequired,
  urlValues: PropTypes.shape().isRequired,
};

const mapStateToProps = (state) => ({
  message: state.app.bill.perBill.perBillInfo.message,
  perBillCsl: state.app.bill.perBill.perBillInfo.perBillCsl,
  perBillC: state.app.bill.perBill.perBillInfo.perBillC,
  perBillBillNo: state.app.bill.perBill.perBillInfo.perBillBillNo,
  perPayment: state.app.bill.perBill.perBillInfo.perPayment,
  conditions: state.app.bill.perBill.perBillGuide.conditions,
  urlValues: state.app.bill.perBill.perBillInfo.urlValues,
});

const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    // 請求書情報を取得
    dispatch(getPerBillInfoRequest({ params }));
    // 個人請求管理情報の取得の対処する
    dispatch(getPerBillNoRequest({ formName, params }));
  },
  onDelete: (params, redirect) => {
    // 請求書情報を取得
    dispatch(deletePerBillInfoRequest({ params, redirect }));
  },
  // 請求書統合処理
  onOpenMergeGuideRequest: (params) => {
    dispatch(openMergeGuideRequest({ params }));
  },
  // 請求書コメント オープン
  onOpenPerBillGuide: () => {
    dispatch(openPerBillGuide());
  },
  // 請求書コメントポップ初期化
  initializePerBillComment: () => {
    dispatch(initializeBillComment());
  },
  onOpenPerBillncomeGuide: (params) => {
    dispatch(openPerBillIncomeGuide(params));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(PerBillInfo);
