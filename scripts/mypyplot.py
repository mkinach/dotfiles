# mypyplot.py: automatic plotting of two-column data

import matplotlib.pyplot as plt
import argparse

width = 2 * 3.408  # revtex single-column width
height = width / 1.618  # golden ratio


def plot_data(files):
    fig, ax = plt.subplots(figsize=(width, height))  # set the figure size

    for i, file in enumerate(files):
        # read data from file
        data = []
        with open(file, 'r') as f:
            for line in f:
                x, y = map(float, line.strip().split())
                data.append((x, y))

        # separate x and y values
        x = [point[0] for point in data]
        if args.scale:
            y = [point[1] * float(args.scale)**i for point in data]
            clabel = str(float(args.scale)**i) + ' * ' + file
        else:
            y = [point[1] for point in data]
            clabel = file

        # plot data
        ax.plot(x, y, label=clabel, linewidth=2.5)

    # set labels and title, if desired
    ax.set_xlabel(args.xlabel) if args.xlabel else None
    ax.set_ylabel(args.ylabel) if args.ylabel else None
    ax.set_title(args.title) if args.title else None

    # plot on logarithmic scale, if desired
    plt.xscale('log') if args.logx else None
    plt.yscale('log') if args.logy else None

    # set x-axis and y-axis limits, if desired
    plt.xlim(left=float(args.xmin)) if args.xmin else None
    plt.xlim(right=float(args.xmax)) if args.xmax else None
    plt.ylim(bottom=float(args.ymin)) if args.ymin else None
    plt.ylim(top=float(args.ymax)) if args.ymin else None

    # add gridlines
    ax.grid(True)

    # add legend
    ax.legend(bbox_to_anchor=(0.25, 0.25),
              loc='upper left') if args.legend else ax.legend()

    # remove excess margins
    ax.margins(0, 0)

    # show the plot and save to a file
    plt.savefig('/tmp/mypyplot.png', dpi=600, bbox_inches='tight')
    print("Plot saved to /tmp/mypyplot.png")
    plt.show()


if __name__ == '__main__':
    # parse command-line arguments for file names
    parser = argparse.ArgumentParser(
        description='Plot two-column numeric data from files')
    parser.add_argument('file',
                        metavar='file',
                        type=str,
                        nargs='+',
                        help='input data file(s)')
    parser.add_argument(
        '-x',
        '--xlabel',
        action='store',
        help='x-axis label (must enclose in quotes if including spaces)')
    parser.add_argument(
        '-y',
        '--ylabel',
        action='store',
        help='y-axis label (must enclose in quotes if including spaces)')
    parser.add_argument(
        '-t',
        '--title',
        action='store',
        help='plot title (must enclose in quotes if including spaces)')
    parser.add_argument('-s',
                        '--scale',
                        action='store',
                        help='set scaling factor (integer)')
    parser.add_argument('-l',
                        '--legend',
                        action='store_true',
                        help='move legend')
    parser.add_argument('--xmin',
                        action='store',
                        help='set minimum x-value (float)')
    parser.add_argument('--xmax',
                        action='store',
                        help='set maximum x-value (float)')
    parser.add_argument('--ymin',
                        action='store',
                        help='set minimum y-value (float)')
    parser.add_argument('--ymax',
                        action='store',
                        help='set maximum y-value (float)')
    parser.add_argument('--logx',
                        action='store_true',
                        help='use logarithmic x-scale')
    parser.add_argument('--logy',
                        action='store_true',
                        help='use logarithmic y-scale')
    args = parser.parse_args()

    # call the plotting function
    plot_data(args.file)
