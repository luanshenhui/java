import React from 'react';
import styled from 'styled-components';
import PropTypes from 'prop-types';
import ViewOldJudCommentHeaderForm from './ViewOldJudCommentHeaderForm';
import ViewOldJudCommentBody from './ViewOldJudCommentBody';

const ViewOldDiv = styled.div`
   height:680px;
   overflow-y: auto
`;

const ViewOldJudCommentList = (props) => {
  const { match } = props;
  const { winmode } = match.params;
  return (
    <div>
      {
        (winmode === '1') ?
          <div>
            <ViewOldJudCommentHeaderForm />
            <ViewOldDiv>
              <ViewOldJudCommentBody />
            </ViewOldDiv>
          </div>
          :
          <div>
            <ViewOldJudCommentHeaderForm />
            <ViewOldJudCommentBody />
          </div>
      }
    </div>
  );
};

// propTypesの定義
ViewOldJudCommentList.propTypes = {
  match: PropTypes.shape().isRequired,
};

export default ViewOldJudCommentList;
