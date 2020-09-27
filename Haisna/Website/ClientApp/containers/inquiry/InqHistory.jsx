import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

import moment from 'moment';

import Table from '../../components/Table';
import LabelCourseWebColor from '../../components/control/label/LabelCourseWebColor';

const Wrapper = styled.div`
  height: 350px;
  overflow-y: auto;
`;

const InqHistory = ({ perid, personInf, consultHistory }) => (
  <Wrapper>
    {personInf.lastname &&
      <div>{perid} <strong>{personInf.lastname} {personInf.firstname}</strong> {`(${personInf.lastkname} ${personInf.firstkname == null ? '' : personInf.firstkname})`}
        <span style={{ display: 'block', marginLeft: '65px' }}>
          {`${personInf.birthyearshorteraname}${personInf.birtherayear}.${moment(personInf.birth).format('MM')}.${moment(personInf.birth).format('DD')}生`}  {personInf.gendername}
        </span>
      </div>
    }
    <Table>
      <thead>
        <tr>
          <th>受診日</th>
          <th>コース</th>
          <th>年齢</th>
        </tr>
      </thead>
      <tbody>
        {consultHistory && consultHistory.map((rec) => (
          <tr key={rec.csldate}>
            <td>{moment(rec.csldate).format('YYYY/M/D h:mm:ss A').replace(' 12:00:00 AM', '')}</td>
            <td><LabelCourseWebColor webcolor={rec.webcolor} />{rec.csname}</td>
            <td>{`${rec.age}歳`}</td>
          </tr>
        ))}
      </tbody>
    </Table>
  </Wrapper>
);

InqHistory.propTypes = {
  perid: PropTypes.string.isRequired,
  personInf: PropTypes.shape().isRequired,
  consultHistory: PropTypes.arrayOf(PropTypes.shape()),
};

// defaultPropsの定義
InqHistory.defaultProps = {
  consultHistory: null,
};

export default InqHistory;

