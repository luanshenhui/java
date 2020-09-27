/**
 * @file 結果参照 対象者
 */
import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import moment from 'moment';

// 共通コンポーネント
import SectionBar from '../../components/SectionBar';
import Table from '../Table';
import Button from '../control/Button';

// レイアウト
const PersonGroup = styled.div`
  display: table;
`;
const PerIdField = styled.div`
  display: table-cell;
`;
const PersonField = styled.div`
`;
const ButtonGroup = styled.div`
`;
const ConsultGroup = styled.div`
`;

// レンダリング
const InqHistory = ({ person, consults, onSelected, onClickRslHistory, history }) => {
  // 受診日クリック時の処理
  const cslDateClickHandler = (values) => {
    onSelected(values);
    return false;
  };

  return (
    <div>
      <div>
        「{person.lastkname}　{person.firstkname}」
      </div>
      <div>
        の受診歴は{consults.totalcount}件ありました。
      </div>
      <SectionBar title="対象者" />
      <div>
        <PersonGroup>
          <PerIdField>
            {person.perid}
          </PerIdField>
          <PersonField>
            {person.lastname}　{person.firstname}（{person.lastkname}　{person.firstkname}）
          </PersonField>
          <PersonField>
            {moment(person.birth).format('YYYY.MM.DD生')}　{person.gendername}
          </PersonField>
        </PersonGroup>
        <ButtonGroup>
          <Button value="対象者変更" onClick={() => history.push({ pathname: '/contents/inquiry' })} />
          <Button value="経年変化" onClick={() => onClickRslHistory()} />
        </ButtonGroup>
        <ConsultGroup>
          {Array.isArray(consults.data) &&
            <Table>
              <thead>
                <tr>
                  <th>受診日</th>
                  <th>コース</th>
                  <th>年齢</th>
                </tr>
              </thead>
              <tbody>
                {consults.data.map((rec) => (
                  <tr key={`${rec.rsvno}`}>
                    <td><a href="#" onClick={() => cslDateClickHandler({ rsvno: rec.rsvno })}>{moment(rec.csldate).format('YYYY/MM/DD')}</a></td>
                    <td><span style={{ color: `#${rec.webcolor}` }}>■</span>{rec.cssname}</td>
                    <td>{rec.age}歳</td>
                  </tr>
                ))}
              </tbody>
            </Table>
          }
        </ConsultGroup>
      </div>
    </div>
  );
};

// propTypes定義
InqHistory.propTypes = {
  history: PropTypes.shape().isRequired,
  person: PropTypes.shape().isRequired,
  consults: PropTypes.shape().isRequired,
  onSelected: PropTypes.func.isRequired,
  onClickRslHistory: PropTypes.func.isRequired,
};

export default InqHistory;
