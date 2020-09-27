import React from 'react';
import styled from 'styled-components';
import MuiChip from '@material-ui/core/Chip';

const StyledChip = styled(MuiChip)`
  && {
    background-color: #f5f5f5;
    border-radius: 4px;
    color: #4d4d4d;
    height: 20px;
    line-height: 20px;
    margin: 4px 0 0 0;
  }

  > span {
    padding: 0 18px 0 5px;
  }

  svg {
    font-size: 14px;
    height: 20px;
    width: 20px;
  }
`;

const Chip = (props) => (
  <StyledChip {...props} />
);

export default Chip;
