import styled from 'styled-components';

const Table = styled.table`
  border-collapse: collapse;
  width: 100%;
  tr {
    height: 28px;
  }
  thead {
    th {
      border-bottom: 1px solid #999;
      color: #666;
      font-weight: bold;
      padding: 5px 5px 1px;
      text-align: left;
      white-space: nowrap;
    }
  }
  tbody {
    tr:nth-child(odd) {
      background: #f5f5f5;
    }
    tr:hover {
      background: #fffae6;
      cursor: pointer;
    }
    td {
      border-bottom: 1px solid #bebebe;
      padding: 3px 5px;
    }
  }
`;

export default Table;
