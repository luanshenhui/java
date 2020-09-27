import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { formValueSelector } from 'redux-form';
import Table from '../../components/Table';
import { rslMainShowRequest } from '../../modules/result/resultModule';

const prefixInteger = (dayid) => {
  let res;
  if (dayid && dayid.toString().length === 1) {
    res = `000${dayid}`;
  } else if (dayid && dayid.toString().length === 2) {
    res = `00${dayid}`;
  } else if (dayid && dayid.toString().length === 3) {
    res = `0${dayid}`;
  } else if (dayid && dayid.toString().length === 4) {
    res = `${dayid}`;
  }
  return res;
};

class RslDailyListBody extends React.Component {
  handleShowDetailClick(rsvno, dayid) {
    const { onShowDetail, rslDailyListHeaderConditions } = this.props;
    const params = rslDailyListHeaderConditions;
    params.rsvno = rsvno;
    params.dayid = dayid.toString();
    onShowDetail(params);
  }

  render() {
    const { data } = this.props;
    return (
      <Table striped hover>
        <thead>
          {data && data.length > 0 && (
          <tr>
            <th>当日ＩＤ</th>
            <th>受診コース</th>
            <th>個人氏名</th>
            <th>個人ＩＤ</th>
          </tr>
          )}
        </thead>
        <tbody>
          {data && data !== null && data.map((rec) => (
            <tr key={rec.dayid}>
              <td>{prefixInteger(rec.dayid)}</td>
              <td>
                <span style={{ color: `#${rec.webcolor}` }}>■</span>{rec.cssname}
              </td>
              <td>
                <span style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}>
                  <a role="presentation" onClick={() => (this.handleShowDetailClick(rec.rsvno, rec.dayid))} >
                    {rec.lastname}&nbsp;{rec.firstname}
                  </a>
                </span>
              </td>
              <td>{rec.perid}</td>
            </tr>
          ))}
        </tbody>
      </Table>
    );
  }
}

// propTypesの定義
RslDailyListBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onShowDetail: PropTypes.shape().isRequired,
  rslDailyListHeaderConditions: PropTypes.shape().isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const selector = formValueSelector('rslDailyListHeader');
  return {
    rslDailyListHeaderConditions: {
      csldate: selector(state, 'csldate'),
      cscd: selector(state, 'cscd'),
      sortkey: selector(state, 'sortkey'),
      cntlno: selector(state, 'cntlno'),
    },
    data: state.app.result.result.rslDailyList.data,
  };
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onShowDetail(params) {
    dispatch(rslMainShowRequest({ params }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(RslDailyListBody);
