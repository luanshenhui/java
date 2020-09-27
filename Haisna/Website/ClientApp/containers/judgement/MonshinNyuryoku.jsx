import React from 'react';
import styled from 'styled-components';
import PropTypes from 'prop-types';
import MonshinNyuryokuHeader from './MonshinNyuryokuHeader';
import MonshinNyuryokuBody from './MonshinNyuryokuBody';

const MonshinDiv = styled.div`
   height:680px;
   overflow-y: auto
`;

const MonshinNyuryoku = (props) => {
  const { match } = props;
  const { winmode } = match.params;
  return (
    <div>
      {(winmode === '1') && (
        <div>
          <MonshinNyuryokuHeader />
          <MonshinDiv><MonshinNyuryokuBody /></MonshinDiv>
        </div>
      )}
      {(winmode === '0') && (
        <div>
          <MonshinNyuryokuHeader />
          <MonshinNyuryokuBody />
        </div>
      )}
    </div>
  );
};

// propTypesの定義
MonshinNyuryoku.propTypes = {
  match: PropTypes.shape().isRequired,
};

export default MonshinNyuryoku;
