import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';

import { connect } from 'react-redux';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';

import Table from '../../../components/Table';

const SearchedKeyword = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

class HainsLogBody extends React.Component {
  constructor(props) {
    super(props);
    this.highlight = this.highlight.bind(this);
  }
  // 文字列検索の場合Bold化
  highlight(curMessage) {
    const { message } = this.props;

    if (message !== '' && curMessage) {
      const messageArray = curMessage.split(message);
      const array = [];
      for (let i = 0; i < messageArray.length; i += 1) {
        array.push(messageArray[i]);
        if (i === messageArray.length - 1) {
          break;
        }
        array.push(<SearchedKeyword key={i}>{message}</SearchedKeyword>);
      }
      return array;
    }
    return curMessage;
  }

  render() {
    const { data } = this.props;
    return (
      <Table striped hover>
        <thead>
          <tr>
            <th>処理名</th>
            <th>状態</th>
            <th>メッセージ１</th>
            <th>メッセージ２</th>
            <th>処理対象行</th>
            <th>処理開始日時</th>
            <th>StatementNo</th>
          </tr>
        </thead>
        <tbody>
          {data.map((rec) => (
            <tr key={rec.statementno}>
              <td>{rec.transactionname}(ID:{rec.transactionid})</td>
              {
                (() => {
                  switch (rec.informationdiv) {
                    case 'I':
                      return <td>正常</td>;
                    case 'E':
                      return <td>エラー</td>;
                    case 'W':
                      return <td>警告</td>;
                    default:
                      return <td>正常</td>;
                  }
                })()
              }
              <td>
                {
                  this.highlight(rec.message1)
                }
              </td>
              <td>
                {
                  this.highlight(rec.message2)
                }
              </td>
              <td>{rec.lineno}</td>
              <td>
                {
                  rec.insdate && moment(rec.insdate).format('YYYY/MM/DD h:mm:ss')
                }
              </td>
              <td>{rec.statementno}</td>
            </tr>
          ))}
        </tbody>
      </Table>
    );
  }
}

// propTypesの定義
HainsLogBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  message: PropTypes.string.isRequired,
};

const mapStateToProps = (state) => ({
  message: state.app.preference.hainsLog.hainsLogList.message,
  totalCount: state.app.preference.hainsLog.hainsLogList.totalCount,
  data: state.app.preference.hainsLog.hainsLogList.data,
});

export default withRouter(connect(mapStateToProps)(HainsLogBody));
