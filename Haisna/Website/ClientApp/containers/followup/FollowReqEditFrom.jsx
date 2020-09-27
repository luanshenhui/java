import React from 'react';
import PropTypes from 'prop-types';
import { getFormValues, reduxForm, blur } from 'redux-form';
import { connect } from 'react-redux';

import Button from '../../components/control/Button';
import FollowReq from '../report/FollowReqEdit';

const formName = 'FollowReqEditFrom';

class FollowReqEdit extends React.Component {
  constructor(props) {
    super(props);

    this.handleClearClick = this.handleClearClick.bind(this);
  }

  // クリアボタンを押下
  handleClearClick() {
    const { setValue } = this.props;
    setValue('folitem', null);
    setValue('folnote', null);
  }

  render() {
    const { followInfo } = this.props;
    return (
      <form>
        <table>
          <tbody>
            <tr style={{ textAlign: 'center' }}>
              <td style={{ whiteSpace: 'pre', width: 120, backgroundColor: '#cccccc' }}>健診項目</td>
              <td style={{ whiteSpace: 'pre', width: 120, backgroundColor: '#eeeeee' }}><strong>{followInfo.judclassname}</strong></td>
              <td style={{ width: 20 }}>&nbsp;</td>
              <td style={{ backgroundColor: '#cccccc', width: 120 }}>判定</td>
              <td style={{ backgroundColor: '#eeeeee', width: 160 }}>
                <strong>{followInfo && followInfo.judcd}&nbsp;&nbsp;(&nbsp;最終判定&nbsp;：&nbsp;{followInfo && followInfo.rsljudcd}&nbsp;)</strong>
              </td>
              <td>
                <Button style={{ marginLeft: '5px' }} onClick={() => this.handleClearClick()} value="クリア" />
              </td>
            </tr>
          </tbody>
        </table>
        <FollowReq followInfo={followInfo} />
      </form>
    );
  }
}

const FollowReqEditFrom = reduxForm({
  form: formName,
})(FollowReqEdit);

// propTypesの定義
FollowReqEdit.propTypes = {
  setValue: PropTypes.func.isRequired,
  followInfo: PropTypes.shape().isRequired,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    followInfo: state.app.followup.follow.followReqEditGuide.followInfo,
  };
};

const mapDispatchToProps = (dispatch) => ({
  onSavePrint: () => {
    // TODO
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(FollowReqEditFrom);
