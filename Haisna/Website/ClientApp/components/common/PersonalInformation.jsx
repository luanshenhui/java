/**
 * @file 個人ID、氏名、誕生日、性別のフォーマット
 */
import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

// レイアウト
const Wrapper = styled.div`
  display: table;
`;
const PerIdCell = styled.div`
  display: table-cell;
`;
const PersonInfo = styled.div`
  display: table-cell;
  padding-left: 15px;
`;
const PersonLine = styled.div`
`;

const PeronalInformation = (props) => {
  const { perid, lastname, firstname, lastkname, firstkname, birth, gender } = props;
  return (
    <Wrapper>
      <PerIdCell>
        {perid}
      </PerIdCell>
      <PersonInfo>
        <PersonLine>
          {lastname}　{firstname}　{(lastkname || firstkname) && `(${lastkname}${'　'}${firstkname})`}
        </PersonLine>
        <PersonLine>
          {birth}　{gender}
        </PersonLine>
      </PersonInfo>
    </Wrapper>
  );
};

// propTypesを定義
PeronalInformation.propTypes = {
  perid: PropTypes.string,
  lastname: PropTypes.string,
  firstname: PropTypes.string,
  lastkname: PropTypes.string,
  firstkname: PropTypes.string,
  birth: PropTypes.string,
  gender: PropTypes.number,
};

// defaultTypesを定義
PeronalInformation.defaultProps = {
  perid: null,
  lastname: null,
  firstname: null,
  lastkname: null,
  firstkname: null,
  birth: null,
  gender: null,
};

export default PeronalInformation;
