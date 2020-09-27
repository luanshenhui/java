import React from 'react';
import styled from 'styled-components';

import Pagination from '../components/Pagination';

const Caption = styled.p`
  font-weight: bold;
  margin-top: 10px;
`;

const totalCount = 250;
const limit = 20;

class PaginationExample extends React.Component {
  constructor(props) {
    super(props);
    this.state = { page: 1 };
  }

  render() {
    return (
      <div>
        <Caption>ページネーション</Caption>
        <Pagination
          onSelect={(page) => {
            this.setState({ page });
          }}
          totalCount={totalCount}
          startPos={((this.state.page - 1) * limit) + 1}
          rowsPerPage={limit}
        />
      </div>
    );
  }
}

export default PaginationExample;
