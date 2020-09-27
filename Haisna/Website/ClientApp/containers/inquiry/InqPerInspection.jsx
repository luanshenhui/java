import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

import moment from 'moment';

import Table from '../../components/Table';
import Button from '../../components/control/Button';

const Wrapper = styled.div`
  overflow-x: auto;
`;

const SmallTitleSpan = styled.span`
  font-weight: bold;
  display: block;
`;

// 受診歴見出し
const titleArry = ['直近の受診日', '１つ前の受診日'];

const InqPerInspection = ({ consultHistoryIns, perResultList, mode }) => (
  <Wrapper>
    <SmallTitleSpan>個人検査情報</SmallTitleSpan>
    {perResultList && perResultList.length > 0 ?
      <Table style={{ whiteSpace: 'nowrap', marginTop: '10px' }}>
        <thead>
          <tr>
            <th>検査項目名</th>
            <th>検査結果</th>
            <th>検査日</th>
          </tr>
        </thead>
        <tbody>
          {perResultList.map((rec) => (
            <tr key={rec.key}>
              <td>{rec.itemname}</td>
              <td>{rec.result}</td>
              <td>{rec.ispdate && moment(rec.ispdate).format('YYYY/M/D hh:mm:ss A').replace(' 12:00:00 AM', '')}</td>
            </tr>
          ))}
        </tbody>
      </Table>
      : <p>個人検査情報は存在しません。</p>
    }

    <SmallTitleSpan style={{ marginTop: '20px' }}>受診歴</SmallTitleSpan>
    {consultHistoryIns && consultHistoryIns.length > 0 ?
      <Table style={{ width: '400px' }}>
        <tbody>
          {consultHistoryIns.map((rec, index) => (
            <tr key={rec.rsvno}>
              <td>{titleArry[index]}</td>
              <td>{moment(rec.csldate).format('YYYY/M/D')}</td>
              <td>{rec.csname}</td>
            </tr>
          ))}
        </tbody>
      </Table>
      : <p>受診歴は存在しません。</p>
    }

    {mode !== '1' &&
      <div style={{ textAlign: 'right' }}>
        <Button value="キャンセル" />
      </div>
    }
  </Wrapper>
);

InqPerInspection.propTypes = {
  consultHistoryIns: PropTypes.arrayOf(PropTypes.shape()),
  perResultList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  mode: PropTypes.string.isRequired,
};

// defaultPropsの定義
InqPerInspection.defaultProps = {
  consultHistoryIns: null,
};

export default InqPerInspection;
