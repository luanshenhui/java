import React from 'react';
import styled from 'styled-components';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import Moment from 'moment';
import { FieldGroup, FieldSet } from '../../components/Field';
import Label from '../../components/control/Label';
import Table from '../../components/Table';
import MoneyFormat from './MoneyFormat';

// カスタマイズfontラベル
const Font = styled.span`
    size: ${(props) => props.size};
    color: #${(props) => props.color};
`;

const PerBillSearchBody = ({ totalCount, data, conditions }) => (
  <div>
    <FieldGroup>
      <FieldSet>
        <Label>「
          <Font color="ff6600">
            <b>
              {conditions.startDmdDate === ('' || null) ? Moment().format('YYYY/MM/DD') : conditions.startDmdDate}～
              {conditions.endDmdDate === ('' || null) ? Moment().format('YYYY/MM/DD') : conditions.endDmdDate}
            </b>
          </Font>」
          の請求書一覧を表示しています。
        </Label>
      </FieldSet>
      <FieldSet>
        {totalCount !== null && (<Label>対象請求書は<Font color="ff6600"><b>{totalCount === null ? 0 : totalCount}</b></Font>枚です。</Label>)}
      </FieldSet>
      <FieldSet>
        <Label><Font color="cc9999">●</Font>予約番号をクリックすると予約情報、請求書Noをクリックすると該当する請求書情報が表示されます。</Label>
      </FieldSet>
    </FieldGroup>
    <Table striped hover>
      <thead>
        <tr bgcolor="cccccc">
          <th>請求書No</th>
          <th>対象予約番号</th>
          <th>請求日</th>
          <th>受診コース</th>
          <th>個人ID</th>
          <th>当日ID</th>
          <th>個人氏名</th>
          <th>他</th>
          <th>受診団体</th>
          <th style={{ textAlign: 'right' }}>合計</th>
          <th>入金日</th>
          <th style={{ textAlign: 'right' }}>入金</th>
          <th>取消伝票</th>
        </tr>
      </thead>
      <tbody>
        {totalCount !== null && (data.map((rec) => (
          <tr key={`${rec.dmddate}-${rec.billseq}-${rec.branchno}`} style={{ background: rec.delflg === 1 ? '#FFC0CB' : '' }}>
            {rec.rsvno !== '' && rec.rsvno != null ?
              <td>
                <Link to={`/contents/demand/perbill/info/${Moment(rec.dmddate).format('YYYY-MM-DD')}/${rec.billseq.toString().padStart(5, '0')}/${rec.branchno}/${rec.rsvno}`}>
                  <Font color="006699">{Moment(rec.dmddate).format('YYYYMMDD')}{rec.billseq.toString().padStart(5, '0')}{rec.branchno}</Font>
                </Link>
              </td>
              :
              <td>
                <Link to={`/contents/demand/perbill/createPerBill/${Moment(rec.dmddate).format('YYYY-MM-DD')}/${rec.billseq.toString().padStart(5, '0')}/${rec.branchno}/update`}>
                  <Font color="006699">{Moment(rec.dmddate).format('YYYYMMDD')}{rec.billseq.toString().padStart(5, '0')}{rec.branchno}</Font>
                </Link>
              </td>
            }
            <td><Link to={`/contents/reserve/main/${rec.rsvno}`} ><Font color="006699">{rec.rsvno}</Font></Link></td>
            <td>{Moment(rec.dmddate).format('YYYY/MM/DD')}</td>
            {rec.csname !== '' && rec.csname != null ? <td><Font color={rec.webcolor}>■</Font>{rec.csname}</td> : <td>{}</td>}
            <td>{rec.perid}</td>
            {rec.dayid !== '' && rec.dayid != null ? <td>{rec.dayid.toString().padStart(4, '0')}</td> : <td>{}</td>}
            <td>{rec.lastname}{rec.firstname}
              <Link to={`/contents/preference/person/edit/${rec.perid}`} >
                <Font color="666666" size="-1">({rec.lastkname}{rec.firstkname})</Font>
              </Link>
            </td>
            {rec.percount === 1 ? <td>{}</td> : <td>{rec.percount - 1}名</td>}
            <td>{rec.orgsname}</td>
            <td align="right"><b><MoneyFormat money={rec.totalprice} /></b></td>
            {rec.paymentdate != null ? <td>{Moment(rec.paymentdate).format('YYYY/MM/DD')}</td> : <td>{}</td>}
            {rec.paymentdate != null ? <td align="right"><MoneyFormat money={rec.price} /></td> : <td align="right">未収</td>}
            {rec.delflg === 1 ? <td>取消</td> : <td>{}</td>}
          </tr>
        )))}
      </tbody>
    </Table>
  </div>
);


// propTypesの定義
PerBillSearchBody.propTypes = {
  totalCount: PropTypes.number,
  conditions: PropTypes.shape().isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};
PerBillSearchBody.defaultProps = {
  totalCount: null,
};
// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  data: state.app.bill.perBill.perBillList.data,
  totalCount: state.app.bill.perBill.perBillList.totalCount,
  conditions: state.app.bill.perBill.perBillSearch.conditions,
});

export default connect(mapStateToProps)(PerBillSearchBody);

