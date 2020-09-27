import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

import Table from '../../components/Table';

const FriendsListBody = ({ data }) => (
  <Table striped hover>
    <thead>
      <tr style={{ color: '#eeeeee' }}>
        <th width="80px" />
        <th width="80px">個人ＩＤ</th>
        <th width="330px">氏名</th>
        <th width="80px" >予約番号</th>
        <th width="150px">受診団体</th>
        <th width="120px">受診コース</th>
        <th width="120px">予約群</th>
      </tr>
    </thead>
    <tbody>
      {data.getfriendsdata && data.getfriendsdata.map((rec, i) => {
        if (i >= 1) {
          return (
            <tr key={i.toString()}>
              <td>{data.getwelcomedata && data.getwelcomedata.compperid === rec.perid ? '同伴者' : 'お連れ様'}</td>
              <td>{rec.perid}</td>
              <td>{rec.lastname}&nbsp;{rec.firstname}
                <span style={{ fontSize: '6px' }}><b>({rec.lastkname}&nbsp;{rec.firstkname})</b></span>
              </td>
              <td><Link to={`../Reserve/rsvMain.asp?rsvNo="${rec.rsvno}`}>{rec.rsvno}</Link></td>
              <td>{rec.orgsname}</td>
              <td>{rec.csname}</td>
              <td>{rec.rsvgrpname}</td>
            </tr>
          );
        }
        return true;
      })}
    </tbody>
  </Table>
);

// propTypesの定義
FriendsListBody.propTypes = {
  data: PropTypes.shape(),
};

FriendsListBody.defaultProps = {
  data: {},
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  data: state.app.reserve.consult.receiptMainGuide.data,
});

export default connect(mapStateToProps)(FriendsListBody);
