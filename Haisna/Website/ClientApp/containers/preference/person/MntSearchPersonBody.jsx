import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import styled from 'styled-components';
import moment from 'moment';
import Table from '../../../components/Table';

const Wrapper = styled.span`
  font-size: 9px;
`;

const MntSearchPersonBody = ({ data }) => (
  <Table striped hover>
    <thead>
      <tr>
        <th>個人ＩＤ</th>
        <th>氏名</th>
        <th>ローマ字</th>
        <th>性別</th>
        <th>生年月日</th>
        <th>年齢</th>
      </tr>
    </thead>
    <tbody>
      {data.map((rec) => (
        <tr key={`${rec.perid}`}>
          <td><Link to={`/contents/preference/person/edit/${rec.perid}`}>{rec.perid}</Link></td>
          <td><Wrapper>{rec.lastkname} {rec.firstkname}</Wrapper><br /><Link to={`/contents/preference/person/edit/${rec.perid}`}>{rec.lastname} {rec.firstname}</Link></td>
          <td>{rec.romename}</td>
          <td>{(rec.gender === 1) ? '男性' : '女性'}</td>
          <td>{rec.birthyearshorteraname}{rec.birtherayear}.{moment(rec.birth).format('MM')}.{moment(rec.birth).format('DD')}</td>
          <td>{Math.round(`${rec.age}`)}歳</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
MntSearchPersonBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  data: state.app.preference.person.personList.data,
});

export default connect(mapStateToProps)(MntSearchPersonBody);
