import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import PageLayout from '../../layouts/PageLayout';

import SpecialJudView from './SpecialJudView';
import SpecialJudHeader from '../../containers/common/SpecialJudHeader';

class SpecialInterViewTop extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.rsvno = match.params.rsvno;
  }
  render() {
    return (
      <div>
        <PageLayout title="特定健診専用面接" >
          <SpecialJudHeader rsvno={this.rsvno} />
          <SpecialJudView />
        </PageLayout >
      </div>
    );
  }
}
// propTypesの定義
SpecialInterViewTop.propTypes = {
  match: PropTypes.shape().isRequired,
};

const mapStateToProps = () => ({
});

const mapDispatchToProps = () => ({
});

export default connect(mapStateToProps, mapDispatchToProps)(SpecialInterViewTop);
